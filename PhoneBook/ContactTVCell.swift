//
//  ContactTVCell.swift
//  PhoneBook
//

import Foundation

protocol ContactTVCell: class {
    func setCurrentId(currentId : String)
    func setFirstName(firstName : String)
    func setLastName(lastName : String)
    func setPhone(phone : String)
    func setEmail(email : String?)
    func setImage(imageData : Data?)
    func setVisibleLastName(isVisible : Bool)
    func setVisibleEmail(isVisible : Bool)
    func refresh()
    func expand(expanded : Bool)
}
