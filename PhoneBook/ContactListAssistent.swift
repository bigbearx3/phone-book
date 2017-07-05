//
//  ContactListAssistent.swift
//  PhoneBook
//

import Foundation

protocol ContactListAssistent{
    func load()
    func saveWithImage(contact : Contact)
    func updateWithImage(contact : Contact)
    func deleteWithImage(contact : Contact)
    //func save(contact : Contact)
    //func update(contact : Contact)
    //func delete(contact : Contact)
    var delegate : AsistentDelegate! {get set}
}
