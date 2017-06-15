//
//  ContactTVCellPresenter.swift
//  PhoneBook
//

import Foundation

protocol ContactTVCellPresenter {
    init(view: ContactTVCell, contact: Contact)
    func changeView(view: ContactTVCell)
    func initView()
    func expandView()
    func updateData(contact : Contact)
}
