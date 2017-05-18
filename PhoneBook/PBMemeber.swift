//
//  PBMemeber.swift
//  PhoneBook
//

import Foundation

protocol PBMember{
    var contactList : ContactList{get set}
    func refresh()
    func refreshContact()
}
