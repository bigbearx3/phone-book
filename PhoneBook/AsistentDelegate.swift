//
//  AsistentDelegate.swift
//  PhoneBook
//

import Foundation

protocol AsistentDelegate : class{
    func successLoad(contacts : [Contact])
    func failLoad()
    func successUpdate(contact : Contact)
    func failUpdate()
    func successDelete(contactID: String)
    func failDelete()
    func successSave(newContact : Contact)
    func failSave()
}
