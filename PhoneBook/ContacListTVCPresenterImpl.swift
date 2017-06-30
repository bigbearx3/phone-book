//
//  ContacListTVCPresenterImpl.swift
//  PhoneBook
//

import Foundation

class ContacListTVCPresenterImpl : ContacListTVCPresenter{
    private unowned let view: ContacListTVC
    private let contactList: ContactList
    private var contactListInCurrentState : [Contact]
    private var contactCellPresenters : [String : ContactTVCellPresenter] = [:]
    private var isEditingMode = false
    private var sortType : SortType
    required init(view: ContacListTVC, contactList: ContactList, sortType : SortType) {
        self.view = view
        self.contactList = contactList
        self.sortType = sortType        
        contactListInCurrentState = contactList.sortedBy(sortingBy: sortType)
        NotificationCenter.default.addObserver(self, selector: #selector(ContacListTVCPresenterImpl.refreshView), name: Notification.Name(PBNotification.ContactListChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContacListTVCPresenterImpl.closeSpinner), name: Notification.Name(PBNotification.ContactListLoadFail), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContacListTVCPresenterImpl.refreshCell), name: Notification.Name(PBNotification.ContactChanged), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getContactCellPresenter(byIndex : Int, view : ContactTVCell) -> ContactTVCellPresenter{
        let contact = contactListInCurrentState[byIndex]
        var presenter = contactCellPresenters[contact.id]
        if presenter == nil {
            presenter = ContactTVCellPresenterImpl(view: view, contact: contact)
            contactCellPresenters[contact.id] = presenter
        }
        else{
            presenter!.changeView(view: view)
        }
        return presenter!
    }
    
    func getContactId(byIndex : Int) -> String{
        return contactListInCurrentState[byIndex].id
    }
    
    func getContactVCPresenter(for view : ContactVC, contactId : String)->ContactVCPresenter{
        return ContactVCPresenterImpl(view : view, contactList : contactList, currentId : contactId)
    }
    
    func getContactAddEditPresenter(for view : ContactAddEdit, contactId : String?)->ContactAddEditPresenter{
        return ContactAddEditPresenterImpl(view : view, contactList : contactList, currentId : contactId)
    }
    
    func deleteContact(byIndex : Int) {
        let delId = contactListInCurrentState[byIndex].id
        contactList.remove(contactId: delId)
        contactCellPresenters[delId] = nil
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
    
    func changeSort(){
        sortType.next()
        saveSortType()
        refreshView()
    }
    
    func setVisibleButtons(){
        view.setVisibleButtonEdit(isVisible: contactListInCurrentState.count > 1)
        view.setVisibleButtonSortBy(isVisible: !contactListInCurrentState.isEmpty)
    }
    
    func initView(){
        debugPrint("show")
        view.showSpinerActivityIndicator(title: "Loading ...", message: "Please, wait.", minTime: 0, animated: true)
        contactList.load()
        view.setEditingMode(isEditing: isEditingMode)
        view.setTitleSortBy(title: "Sort by " + sortType.toString())
        setVisibleButtons()
    }
    
    @objc func closeSpinner(){
        view.closeSpinerActivityIndicator(animated: true)
    }
    
    @objc func refreshView(){
        debugPrint("close")
        closeSpinner()
        contactListInCurrentState = contactList.sortedBy(sortingBy: sortType)
        setVisibleButtons()
        view.setTitleSortBy(title: "Sort by " + sortType.toString())        
        view.refreshData()        
    }
    
    @objc func refreshCell(notification : Notification){
        if let data = notification.userInfo,
            let updatedId = data["id"],
            let id = updatedId as? String,
            let updatedContact = contactList.get(byID: id),
            let currentCellPresenter = contactCellPresenters[id],
            let  updRowIndex = contactListInCurrentState.index(of: updatedContact){
            currentCellPresenter.updateData(contact : updatedContact)
            currentCellPresenter.initView()
            contactListInCurrentState[updRowIndex] = updatedContact            
        }
    }
}
