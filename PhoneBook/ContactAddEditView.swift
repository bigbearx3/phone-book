//
//  ContactAddEditView.swift
//  PhoneBook
//

import Foundation

protocol ContactAddEditView: class {
    func setEnableSaveButton(enable : Bool)
    func setVisibleDeleteButton(visible : Bool)
    func setTitle(title : String)
    func setFirstName(firstName : String)
    func setLastName(lastName : String)
    func setPhone(phone : String)
    func setEmail(email : String?)
    func close(isEditingMode : Bool)
}
