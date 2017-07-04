//
//  ImageListAssistent.swift
//  PhoneBook
//

import Foundation

protocol ImageListAssistent {
    func getImage(imgId : String) -> Data?
    func saveImage(imgData : Data)
    func deleteImage(imgId : String)
    func updateImage(imgId : String, imgData : Data)
}

