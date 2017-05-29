//
//  Contact.swift
//  PhoneBook
//

import Foundation

struct Contact : Equatable{
    var id : String
    var firstName : String
    var lastName : String
    var phone : String
    var email : String?
    
    init(firstName : String, lastName : String, phone : String, email : String? ) {
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.email = email
        self.id = UUID.init().uuidString
    }
    
    init(id : String ,firstName : String, lastName : String, phone : String, email : String? ) {
        self.init(firstName: firstName, lastName: lastName, phone: phone, email: email)
        self.id = id
    }
    
    static func encode(contact: Contact) {
        let contactClassObject = Coding(contact: contact)
        NSKeyedArchiver.archiveRootObject(contactClassObject, toFile: Coding.path())
    }
    
    static func decode() -> Contact? {
        let contactClassObject = NSKeyedUnarchiver.unarchiveObject(withFile : Coding.path()) as? Coding
        
        return contactClassObject?.contact
    }    
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Contact {
    class Coding: NSObject, NSCoding {
        
        var contact: Contact?
        
        init(contact: Contact) {
            self.contact = contact
            super.init()
        }
        
        class func path() -> String {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask, true).first
            let path = documentsPath?.appending("/Contacts")
            return path!
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard let id = aDecoder.decodeObject(forKey: "id") as? String else { contact = nil; super.init(); return nil }
            guard let firstName = aDecoder.decodeObject(forKey:"firstName") as? String else { contact = nil; super.init(); return nil }
            guard let lastName = aDecoder.decodeObject(forKey:"lastName") as? String else { contact = nil; super.init(); return nil }
            guard let phone = aDecoder.decodeObject(forKey:"phone") as? String else { contact = nil; super.init(); return nil }
            let email = aDecoder.decodeObject(forKey:"email") as? String
            contact = Contact(id: id, firstName: firstName, lastName: lastName, phone: phone, email: email)
            super.init()
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(contact!.id, forKey: "id")
            aCoder.encode(contact!.firstName, forKey: "firstName")
            aCoder.encode(contact!.lastName, forKey: "lastName")
            aCoder.encode(contact!.phone, forKey: "phone")
            aCoder.encode(contact!.email, forKey: "email")
        }
    }
}


extension Contact: Encodable {
    var encoded: Decodable? {
        return Contact.Coding(contact: self)
    }
}

extension Contact.Coding: Decodable {
    var decoded: Encodable? {
        return self.contact
    }
}

protocol Encodable {
    var encoded: Decodable? { get }
}

protocol Decodable {
    var decoded: Encodable? { get }
}


extension Sequence where Iterator.Element: Encodable {
    var encoded: [Decodable] {
        return self.filter({ $0.encoded != nil }).map({ $0.encoded! })
    }
}


extension Sequence where Iterator.Element: Decodable {
    var decoded: [Encodable] {
        return self.filter({ $0.decoded != nil }).map({ $0.decoded! })
    }
}
