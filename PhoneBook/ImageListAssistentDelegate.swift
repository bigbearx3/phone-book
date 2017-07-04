//
//  ImageListAssistentDelegate.swift
//  PhoneBook
//

import Foundation

protocol ImageListAssistentDelegate : class{
    func successLoad(imgId  : String)
    func failLoad()
    func successUpdate(imgId: String)
    func failUpdate()
    func successDelete(imgId: String)
    func failDelete()
    func successSave(newImgData : Data)
    func failSave()
}

