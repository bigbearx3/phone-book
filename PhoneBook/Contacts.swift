//
//  Contacts.swift
//  PhoneBook
//

import Foundation


struct Contact{
    let id : UUID
    var firstName : String
    var lastName : String
    var phone : String
    var email : String
    init(firstName : String, lastName : String, phone : String, email : String ) {
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.email = email
        self.id = UUID.init()
    }
}

class PhoneBook{
    private var contacts : [Contact] = []
    
    private func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(PhoneBook.addAction), name: Notification.Name("AddNewContact"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PhoneBook.addAction), name: Notification.Name("EditContact"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PhoneBook.addAction), name: Notification.Name("DeleteContact"), object: nil)
    }
    
    @objc private func editAction(notification : Notification){
        if let userInfo = notification.userInfo,
            let firstName  = userInfo["firstName"] as? String,
            let lastName  = userInfo["lastName"] as? String,
            let phone  = userInfo["phone"] as? String,
            let email     = userInfo["email"]    as? String {
            //add(newContact: Contact(firstName : firstName, lastName : lastName, phone : phone, email : email))
        }
    }
    
    @objc private func deleteAction(notification : Notification){
        if let userInfo = notification.userInfo,
            let firstName  = userInfo["firstName"] as? String,
            let lastName  = userInfo["lastName"] as? String,
            let phone  = userInfo["phone"] as? String,
            let email     = userInfo["email"]    as? String {
            //add(newContact: Contact(firstName : firstName, lastName : lastName, phone : phone, email : email))
        }
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
    
    init() {
        addObservers()
        load()
    }

    
    private func getIndex(contact : Contact)->Int{
        var index = -1
        for i in 0 ... contacts.count - 1 {
            if contacts[i].id == contact.id {
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
    
    public func remove(contact : Contact){
        let index = getIndex(contact: contact)
        if  index > -1 {
            contacts.remove(at: index)
        }
        save()
    }
    
    public func update(contact : Contact){
        let index = getIndex(contact: contact)
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
    private func prepareForJSONConvert()->[[String:[String:String]]]{
        var result : [[String:[String:String]]] = []
        for contact in contacts {
            let arrContact = ["contact":["firstName": contact.firstName, "lastName": contact.lastName, "phone": contact.phone, "email": contact.email]]
            result.append(arrContact)
        }
        return result
    }
    
    private func saveToJsonFile() {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Contacts.json")
        do {
            let data = try JSONSerialization.data(withJSONObject: prepareForJSONConvert(), options: [])
            print(data)
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
    
    private func loadFromJsonFile() -> [Contact]{
        var result : [Contact] = []
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return result}
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("Contacts.json")
        
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let contactsArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: [String: String]]] else { return result}
            print(contactsArray)
            for contactArray in contactsArray{
                if let contactArr = contactArray["contact"]{
                    result.append(Contact(firstName :contactArr["firstName"] ?? "",
                                          lastName : contactArr["lastName"] ?? "",
                                          phone : contactArr["phone"] ?? "",
                                          email : contactArr["email"] ?? ""))
                }
                            }
            
        } catch {
            print(error)
        }
        return result
    }
    
    public func save(){
        saveToJsonFile()
        NotificationCenter.default.post(name: Notification.Name("PhoneBookChanged"), object: nil)
    }
    
    public func load(){
        contacts = loadFromJsonFile()
    }
    
}
