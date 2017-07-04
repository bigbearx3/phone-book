//
//  ContactListAssistent.swift
//  PhoneBook
//

import Foundation

protocol ContactListAssistent{
    func load()
    func save(contact : Contact)
    func update(contact : Contact)
    func delete(contactId : String)
    var delegate : AsistentDelegate! {get set}
}
