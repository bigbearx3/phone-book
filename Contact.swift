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
        let contactClassObject = HelperClass(contact: contact)
        NSKeyedArchiver.archiveRootObject(contactClassObject, toFile: HelperClass.path())
    }
    
    static func decode() -> Contact? {
        let contactClassObject = NSKeyedUnarchiver.unarchiveObject(withFile : HelperClass.path()) as? HelperClass
        
        return contactClassObject?.contact
    }
    
    func prepareForJSON() -> [String:[String:String]] {
        var result = ["contact" :["id": id, "firstName": firstName, "lastName": lastName, "phone": phone]]
        if let mail = email{
            result["contact"]!.updateValue(mail, forKey: "email")
        }
        return result
    }
    
    init?(fromJSON : [String:[String:String]]){
        if let data = fromJSON["contact"],
            let id = data["id"],
            let firstName = data["firstName"],
            let lastName = data["lastName"],
            let phone = data["phone"] {
            self.init(id : id, firstName : firstName, lastName : lastName, phone : phone, email : data["email"])
        }else{
            return nil
        }
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Contact {
    class HelperClass: NSObject, NSCoding {
        
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
