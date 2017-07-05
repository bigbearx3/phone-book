//
//  ImageAssistentDelegate.swift
//  PhoneBook
//

import Foundation

protocol ImageAssistentDelegate : class{
    func successDeleteImage(imgId: String)
    //func failDeleteImage()
    func successSaveImage(newImgData : Data)
   // func failSaveImage()
}

