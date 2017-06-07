//
//  ContactVCPresenter.swift
//  PhoneBook
//

import Foundation

protocol ContactVCPresenter {
    init(view: ContactVC, contactList: ContactList, currentId : String)
    func showNextView()
    func initView()   
}
