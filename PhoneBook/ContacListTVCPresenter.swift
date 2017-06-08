//
//  ContacListTVCPresenter.swift
//  PhoneBook
//

import Foundation

protocol ContacListTVCPresenter {
    init(view: ContacListTVC, contactList: ContactList)
    func showContactView()
    func showContactAddEditView()
    func deleteContact()
    func getNumberOfSection() ->Int
    func getNumberOfRowsInSection(section : Int) -> Int
    func getCellForRowAt(indexPath : IndexPath)
    func sortBy()
    //func initView()
}
