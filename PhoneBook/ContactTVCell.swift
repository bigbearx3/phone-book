//
//  ContactTVCell.swift
//  PhoneBook
//

import Foundation

protocol ContactTVCell: class {
    func setFirstName(firstName : String)
    func setLastName(lastName : String)
    func setPhone(phone : String)
    func setEmail(email : String?)
    func setVisibleLastName(isVisible : Bool)
    func setVisibleEmail(isVisible : Bool)
    func expand()
}
