//
//  ContactVCPresenterImpl.swift
//  PhoneBook
//

import Foundation

class ContactVCPresenterImpl: ContactVCPresenter {
    private unowned let view: ContactVC
    private let contactList: ContactList
    private var currentId : String
    
    required init(view: ContactVC, contactList: ContactList, currentId : String) {
        self.view = view
        self.contactList = contactList
        self.currentId = currentId
        NotificationCenter.default.addObserver(self, selector: #selector(ContactVCPresenterImpl.initView), name: Notification.Name(PBNotification.ContactChanged), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showNextView(){
        view.showEditView(editViewName: "ContactAddEditImpl", model: contactList, currentID: currentId)
    }
    
    @objc func initView(){
        if let contact = contactList.get(byID: currentId){
            view.setFirstName(firstName: contact.firstName)
            view.setLastName(lastName: contact.lastName)
            view.setPhone(phone: contact.phone)
            view.setEmail(email: contact.email)
            view.setTitle(title: contact.fullName)
        }
    }    
}
