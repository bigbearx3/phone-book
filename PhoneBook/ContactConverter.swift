//
//  ContactConverter.swift
//  PhoneBook
//

import Foundation

class ContactConverter{
    var nameId : String
    var nameFirstName : String
    var nameLastName : String
    var nameEmail : String
    var namePhone : String
    var nameLatitude : String
    var nameLongidude : String
    var appId : String
    var nameAppId : String
    
    func convertFrom(rawData : [String : Any]) -> Contact?{
        guard let id = rawData[nameId] as? String else { return nil }
        guard let firstName = rawData[nameFirstName] as? String else { return nil }
        guard let lastName = rawData[nameLastName] as? String else { return nil }
        guard let email = rawData[nameEmail] as? String else { return nil }
        let phone = rawData[namePhone] as? String
        let latitude = rawData[nameLatitude] as? Double
        let longitude = rawData[nameLongidude] as? Double
        return Contact(id : id , firstName : firstName, lastName : lastName,  email : email, phone : phone, imageData : nil, latitude : latitude, longitude : longitude)
    }
    
    func convertTo(contact : Contact) -> [String : String]{
        var result = [String : String]()
        result[nameId] = contact.id
        result[nameFirstName] = contact.firstName
        result[nameLastName] = contact.lastName
        result[nameEmail] = contact.email
        if let phone  = contact.phone{
            result[namePhone] = phone
        }
        if let latitude = contact.latitude,
            let longitude = contact.longitude{
            result[nameLatitude] = String (latitude)
            result[nameLongidude] = String(longitude)
        }
        return result
    }
    
    init(appId : String, nameAppId : String, nameId : String, nameFirstName : String, nameLastName : String, nameEmail : String, namePhone : String, nameLatitude : String, nameLongidude : String) {
        self.nameId = nameId
        self.nameFirstName = nameFirstName
        self.nameLastName = nameLastName
        self.nameEmail = nameEmail
        self.namePhone = namePhone
        self.nameLatitude = nameLatitude
        self.nameLongidude = nameLongidude
        self.appId = appId
        self.nameAppId = appId
    }
}
