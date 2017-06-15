//
//  ContactTVCellPresenterImpl.swift
//  PhoneBook
//

import Foundation

class ContactTVCellPresenterImpl: ContactTVCellPresenter {
    private unowned var view: ContactTVCell
    private var contact: Contact
    private(set) var expanded = false
    
    required init(view: ContactTVCell, contact: Contact) {
        self.view = view
        self.contact = contact
    }
    
    func changeView(view: ContactTVCell){
        self.view = view
    }
    
    func initView(){
        view.setCurrentId(currentId : contact.id)
        view.setFirstName(firstName: expanded ? contact.firstName : contact.fullName)
        view.setLastName(lastName: contact.lastName)
        view.setPhone(phone: contact.phone)
        view.setEmail(email: contact.email)
        view.setVisibleEmail(isVisible: expanded)
        view.setVisibleLastName(isVisible: expanded)
        view.setImage(imageData : contact.imageData)
        view.expand(expanded: expanded)
        //view.refresh()
    }
    
    func updateData(contact : Contact){
        self.contact = contact    
    }
    
    func expandView(){
        expanded = !expanded
        view.setFirstName(firstName: expanded ? contact.firstName : contact.fullName)
        view.setVisibleLastName(isVisible : expanded)
        view.setVisibleEmail(isVisible : expanded)
        view.expand(expanded: expanded)
        view.refresh()
    }
    
    deinit {
        print("presener destroyed")
    }
}
