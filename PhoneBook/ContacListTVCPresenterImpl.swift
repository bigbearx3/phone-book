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
    }
    
    func showContactView(){}
    
    func showContactAddEditView(){}
    
    func deleteContact(){}
    
    func getNumberOfSection() ->Int{
        return 1
    }
    
    func getNumberOfRowsInSection(section : Int) -> Int{
        return contactListInCurrentState.count
    }
    
    func getCellForRowAt(indexPath : IndexPath){}
    
    func sortBy(){
        sortType.next()
        contactListInCurrentState = contactList.sortedBy(sortingBy: sortType)
    }
    
    func initView(){
        view.setEditing(isEditing: false)
        view.setTitleSortBy(title: sortType.toString())
        view.setVisibleButtonEdit(isVisible: <#T##Bool#>)
    }
    
    
    
}
