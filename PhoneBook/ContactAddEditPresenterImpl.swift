//
//  ContactAddEditPresenterImpl.swift
//  PhoneBook
//

import Foundation

class ContactAddEditPresenterImpl : ContactAddEditPresenter{
    private unowned let view: ContactAddEdit
    private let contactList: ContactList
    private var currentId : String?
    private var isEditingMode = false
    
    required init(view: ContactAddEdit, contactList: ContactList, currentId : String?) {
        self.view = view
        self.contactList = contactList
        self.currentId = currentId
    }
    
    func closeView(){
        view.close(isEditingMode: isEditingMode)
    }
    
    func initView(){
        isEditingMode = false
        if let id = currentId, let myContact = contactList.get(byID: id){
            view.setTitle(title: myContact.fullName)
            view.setFirstName(firstName: myContact.firstName)
            view.setLastName(lastName: myContact.lastName)
            view.setPhone(phone: myContact.phone)
            view.setEmail(email: myContact.email)
            isEditingMode = true
        }else{
            view.setTitle(title: "New contact")
        }
        view.setEnableSaveButton(enable: isEditingMode)
        view.setVisibleDeleteButton(visible: !isEditingMode)
    }
    
    func deleteContact(){
        if let id = currentId{
            contactList.remove(contactID: id)
        }
        view.close(isEditingMode : isEditingMode)
    }
    
    func saveContact(firstName: String, lastName: String, phone: String, email: String?){
        let contact : Contact
        if !isEditingMode {
            contact = Contact(firstName: firstName, lastName: lastName, phone: phone, email: email)
        }else{
            contact = Contact(id : currentId!, firstName: firstName, lastName: lastName, phone: phone, email: email)
        }
        contactList.update(contact: contact)
    }
    
    func checkPhone(shouldChangeCharactersIn range: NSRange, replacementString string: String, size : Int) -> Bool{
        let aSet = CharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined()
        return (string == numberFiltered) //&& (size <= 10)
    }
}
