//
//  ContactTVCellPresenter.swift
//  PhoneBook
//

import Foundation

protocol ContactTVCellPresenter {
    init(view: ContactTVCell, contact: Contact) 
    func initView()
    func expandView()
}
