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
}

internal struct AppSetting{
    static let src = "http://10.24.9.10:8080"
    static let appId = Bundle.main.bundleIdentifier ?? "myApp" 
}

