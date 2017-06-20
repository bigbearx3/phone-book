//
//  ContactAddEditPresenter.swift
//  PhoneBook
//

import Foundation

protocol ContactAddEditPresenter {
    init(view: ContactAddEdit, contactList: ContactList, currentId : String?)
    func saveContact(firstName: String, lastName: String, phone: String, email: String?, imageData : Data?)
    func checkPhone(shouldChangeCharactersIn range: NSRange, replacementString string: String, size : Int) -> Bool
    func closeSourcePhoto()
    func presentSoursesPhotoAS()
    func setImage(imageData : Data?)
    func deleteContact()    
    func initView()
    func closeView()    
}
