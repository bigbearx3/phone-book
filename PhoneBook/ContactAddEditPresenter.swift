//
//  ContactAddEditPresenter.swift
//  PhoneBook
//

import Foundation

protocol ContactAddEditPresenter {
    init(view: ContactAddEdit, contactList: ContactList, currentId : String?)
    func saveContact(firstName: String, lastName: String, phone: String, email: String?)
    func checkPhone(shouldChangeCharactersIn range: NSRange, replacementString string: String, size : Int) -> Bool
    func deleteContact()    
    func initView()
    func closeView()    
}
