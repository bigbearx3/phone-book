//
//  ContactTVCellPresenterImpl.swift
//  PhoneBook
//

import Foundation

class ContactTVCellPresenterImpl: ContactTVCellPresenter {
    private unowned let view: ContactTVCell
    private let contact: Contact
    private var expanded = false
    
    required init(view: ContactTVCell, contact: Contact) {
        self.view = view
        self.contact = contact
    }
    
    func initView(){
        view.setFirstName(firstName: contact.firstName)
        view.setLastName(lastName: contact.lastName)
        view.setPhone(phone: contact.phone)
        view.setEmail(email: contact.email)
    }
    
    func expandView(){
        view.setFirstName(firstName: contact.fullName)
        view.setVisibleLastName(isVisible : false)
        view.setVisibleEmail(isVisible : false)
    }
}
