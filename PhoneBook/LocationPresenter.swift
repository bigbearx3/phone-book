//
//  LocationPresenter.swift
//  PhoneBook
//

import Foundation

protocol LocationPresenter{
    init(view: LocationVC, contactList: ContactList, currentId : String?)
    func changeMapType(mapType : Int)    
    func initView()    
}
