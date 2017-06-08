//
//  ContacListTVC.swift
//  PhoneBook
//

import Foundation

protocol ContacListTVC: class {
    func setEditing(isEditing : Bool)
    func setVisibleButtonSortBy(isVisible : Bool)
    func setVisibleButtonEdit(isVisible : Bool)
    func setTitleSortBy(title : String)
    
    /*func setEnableSaveButton(enable : Bool)
    func setVisibleDeleteButton(visible : Bool)
    func setTitle(title : String)
    func setFirstName(firstName : String)
    func setLastName(lastName : String)
    func setPhone(phone : String)
    func setEmail(email : String?)
    func close(isEditingMode : Bool) */
}
