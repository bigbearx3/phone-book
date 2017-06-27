//
//  ContactListAssistent.swift
//  PhoneBook
//

import Foundation

protocol ContactListAssistent{
    //func save(contactArray : [Contact])
    //func load()->[Contact]
    func load()
    func save(contact : Contact)
    func update(contact : Contact)
    func delete(contactId : String)
    var delegate : AsistentDelegate! {get set}
}
