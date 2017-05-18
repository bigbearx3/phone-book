//
//  Contacts.swift
//  ContactList
//

import Foundation

protocol ContactListAssistent{
    func Save(contactList : ContactList)
    func Load(contactList : ContactList)
}

class JsonFileAssistent : ContactListAssistent{
    private var sourceFile : String
    private var destinationFile : String
    
    init(sourceFile : String, destinationFile : String){
        self.sourceFile = sourceFile
        self.destinationFile = destinationFile
    }
    
    func Load(contactList: ContactList) {
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent(destinationFile)
        
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let contactsArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: [String: String]]] else { return }
            print(contactsArray)
            for contactData in contactsArray{
                if let newContact = Contact(fromJSON : contactData){
                    contactList.add(newContact: newContact)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func Save(contactList: ContactList) {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent(destinationFile)
        do {
            let data = try JSONSerialization.data(withJSONObject: contactList.preparedForJSONConvert(), options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
}

struct Contact{
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
}

class ContactList{
    private var contacts : [Contact] = []
    private var helper : ContactListAssistent
    private var inProssesLoading = false
    
    private func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(ContactList.addAction), name: Notification.Name("AddNewContact"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactList.addAction), name: Notification.Name("EditContact"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactList.addAction), name: Notification.Name("DeleteContact"), object: nil)
    }
    
    @objc private func addAction(notification : Notification){
        if let userInfo = notification.userInfo,
            let firstName  = userInfo["firstName"] as? String,
            let lastName  = userInfo["lastName"] as? String,
            let phone  = userInfo["phone"] as? String,
            let email     = userInfo["email"]    as? String {
        add(newContact: Contact(firstName : firstName, lastName : lastName, phone : phone, email : email))
        }
    }
    
    init(assistent : ContactListAssistent) {
        self.helper = assistent
    }
    
    func prepare(){
        addObservers()
        inProssesLoading = true
        helper.Load(contactList: self)
        inProssesLoading = false
    }
    
    private func getIndex(contactID : String)->Int{
        var index = -1
        for i in 0 ... contacts.count - 1 {
            if contacts[i].id == contactID {
                index = i
                break
            }
        }
        return index
    }
    
    public func sortedByFirstName()->[Contact]{
        var result = contacts
        result = result.sorted(by: {$0.firstName < $1.firstName})
        return result
    }
    
    public func sortedByLastName()->[Contact]{
        var result = contacts
        result = result.sorted(by: {$0.lastName < $1.lastName})
        return result
    }
    
    public func add(newContact : Contact){
        contacts.append(newContact)
        save()
    }
    
    public func remove(contactID : String){
        let index = getIndex(contactID: contactID)
        if  index > -1 {
            contacts.remove(at: index)
        }
        save()
    }
    
    public func update(contact : Contact){
        let index = getIndex(contactID: contact.id)
        if index > -1{
            contacts[index].firstName = contact.firstName
            contacts[index].lastName = contact.lastName
            contacts[index].phone = contact.phone
            contacts[index].email = contact.email
        }else{
            contacts.append(contact)
        }
        save()
    }
    
    func preparedForJSONConvert()->[[String:[String:String]]]{
        var result : [[String:[String:String]]] = []
        for contact in contacts {
            result.append(contact.prepareForJSON())
        }
        return result
    }
    
    public func save(){
        if !inProssesLoading{
            helper.Save(contactList: self)
            NotificationCenter.default.post(name: Notification.Name(PBNotification.ContactListChanged.rawValue), object: nil)
        }
    }    
    
    public func load(){
        inProssesLoading = true
        helper.Load(contactList: self)
        inProssesLoading = false
    }
}
