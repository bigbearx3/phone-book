//
//  ContactVC.swift
//  PhoneBook
//

import Foundation

protocol ContactVC: class {
    func setFirstName(firstName : String)
    func setLastName(lastName : String)
    func setPhone(phone : String)
    func setEmail(email : String?)
    func setTitle(title : String)
    func showEditView(editViewName : String, model : ContactList, currentID : String)
}
