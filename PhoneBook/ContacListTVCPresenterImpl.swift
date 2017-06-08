//
//  ContacListTVCPresenterImpl.swift
//  PhoneBook
//

import Foundation

class ContacListTVCPresenterImpl : ContacListTVCPresenter{
    private unowned let view: ContacListTVC
    private let contactList: ContactList
    private var contactListInCurrentState : [Contact]
    private var isEditingMode = false
    private var sortType : SortType
    required init(view: ContacListTVC, contactList: ContactList, sortType : SortType) {
        self.view = view
        self.contactList = contactList
        self.sortType = sortType        
        contactListInCurrentState = contactList.sortedBy(sortingBy: sortType)
        NotificationCenter.default.addObserver(self, selector: #selector(ContacListTVCPresenterImpl.refreshView), name: Notification.Name(PBNotification.ContactListChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContacListTVCPresenterImpl.refreshCell), name: Notification.Name(PBNotification.ContactChanged), object: nil)        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getContactVCPresenter(for view : ContactVC, contactId : String)->ContactVCPresenter{
        return ContactVCPresenterImpl(view : view, contactList : contactList, currentId : contactId)
    }
    
    func getContactAddEditPresenter(for view : ContactAddEdit, contactId : String?)->ContactAddEditPresenter{
        return ContactAddEditPresenterImpl(view : view, contactList : contactList, currentId : contactId)
    }
    
    func deleteContact(byIndex : Int) {
        contactList.remove(contactID: contactListInCurrentState[byIndex].id)
        contactListInCurrentState = contactList.sortedBy(sortingBy: sortType)
        refreshView()
    }
    
    func getNumberOfSection() ->Int{
        return 1
    }
    
    func switchEditing(){
        isEditingMode = !isEditingMode
        view.setEditingMode(isEditing: isEditingMode)
    }
    
    func getNumberOfRowsInSection(section : Int) -> Int{
        return contactListInCurrentState.count
    }
    
    func getContactBy(index : Int) -> Contact{
        return contactListInCurrentState[index]
    }
    
    private func saveSortType(){
        let defaults = UserDefaults.standard
        defaults.set(sortType.rawValue, forKey: "SortField")
        defaults.synchronize()
    }
    
    func sortBy(){
        sortType.next()
        saveSortType()
        contactListInCurrentState = contactList.sortedBy(sortingBy: sortType)
        refreshView()
    }
    
    func setVisibleButtons(){
        view.setVisibleButtonEdit(isVisible: contactListInCurrentState.count > 1)
        view.setVisibleButtonSortBy(isVisible: !contactListInCurrentState.isEmpty)
    }
    
    func initView(){
        view.setEditingMode(isEditing: isEditingMode)
        view.setTitleSortBy(title: "Sort by " + sortType.toString())
        setVisibleButtons()
        
    }
    
    @objc func refreshView(){
        setVisibleButtons()
        view.setTitleSortBy(title: "Sort by " + sortType.toString())
        contactListInCurrentState = contactList.sortedBy(sortingBy: sortType)
        view.refreshData()
        
    }
    
    @objc func refreshCell(notification : Notification){
        if let data = notification.userInfo,
            let updatedId = data["id"],
            let id = updatedId as? String,
            let updatedContact = contactList.get(byID: id),
            let  updRowIndex = contactListInCurrentState.index(of: updatedContact){
            contactListInCurrentState[updRowIndex] = updatedContact
            let indexPath = IndexPath(item: updRowIndex, section: 0)
            view.refreshCellData(byIndexPath : indexPath)
        }
    }
}
