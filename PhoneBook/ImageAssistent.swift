//
//  ImageListAssistent.swift
//  PhoneBook
//

import Foundation

protocol ImageAssistent {    
    func saveImage(contact : Contact, successCallBack : @escaping (_ : Contact) -> Void)
    func deleteImage(contact : Contact, successCallBack : @escaping (_ : Contact) -> Void)
    func updateImage(contact : Contact, successCallBack : @escaping (_ : Contact) -> Void)
    
}

