//
//  AppSettings.swift
//  PhoneBook
//

import Foundation

internal struct PBNotification {
    static let ContactListChanged = "ContactListChanged"
    static let ContactChanged = "ContactChanged"
    static let ContactListLoadFail = "ContactListLoadFail"
    static let ContactSaveFail = "ContactSaveFail"
    static let ContactUpdateFail = "ContactUpdateFail"
    static let ContactDeleteFail = "ContactDeleteFail"
    static let ImageChanged = "ImageChanged"
}

internal struct AppSetting{
    static let src = "http://10.24.9.10:8080"
    static let appId = Bundle.main.bundleIdentifier ?? "myApp"
    static let imageURLString = "https://api.imgur.com/3/image/"
    static let clientId = "Client-ID "
    static let bearer = "Bearer "
    static let loadImageUrl = "https://i.imgur.com/"
    static let ext = ".png"
    
}

