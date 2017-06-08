//
//  ContacListTVCPresenter.swift
//  PhoneBook
//

import Foundation

protocol ContacListTVCPresenter {
    init(view: ContacListTVC, contactList: ContactList, sortType : SortType)
    func deleteContact(byIndex : Int)
    func getNumberOfSection() ->Int
    func getNumberOfRowsInSection(section : Int) -> Int
    func getContactBy(index : Int) ->Contact    
    func getContactVCPresenter(for view : ContactVC, contactId : String)->ContactVCPresenter
    func getContactAddEditPresenter(for view : ContactAddEdit, contactId : String?)->ContactAddEditPresenter
    func sortBy()
    func switchEditing()
    func initView()
}
