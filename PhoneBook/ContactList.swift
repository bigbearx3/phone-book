//
//  Contacts.swift
//  ContactList
//

import Foundation

enum SortField : Int{
    case  lastName = 0
    case  firstName
    mutating func next() {
        switch self {
        case .firstName:
            self = .lastName
        case .lastName:
            self = .firstName
        }
    }
    
    func nextString() -> String {
        switch self {
        case .firstName: return "Last Name"
        case .lastName: return "First Name"
        }
    }
}

protocol ContactListAssistent{
    func save(contactArray : [Contact])
    func load()->[Contact]
}


class JsonFileAssistent : ContactListAssistent{
    private var sourceFile : String
    private var destinationFile : String
    
    init(sourceFile : String, destinationFile : String){
        self.sourceFile = sourceFile
        self.destinationFile = destinationFile
    }
    
    func load() -> [Contact] {
        var result : [Contact] = []
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return result}
        let fileUrl = documentsDirectoryUrl.appendingPathComponent(destinationFile)
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let contactRawArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: [String: String]]] else { return result}            
            for contactData in contactRawArray{
                if let newContact = Contact(fromJSON : contactData){
                    result.append(newContact)
                }
            }
        } catch {
            print(error)
        }
        return result
    }
    
    func save(contactArray : [Contact]) {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent(destinationFile)
        do {
            var praparedForJSON : [[String:[String:String]]] = []
            for contact in contactArray{
                praparedForJSON.append(contact.prepareForJSON())
            }
            let data = try JSONSerialization.data(withJSONObject: praparedForJSON, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
}

class ContactList{
    private var contacts : [Contact] = []
    private var helper : ContactListAssistent
    private var inProssesLoading = false
    
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
    
    private func getIndex(contactID : String)->Int{
        var index = -1
        for i in 0 ..< contacts.count {
            if contacts[i].id == contactID {
                index = i
                break
            }
        }
        return index
    }
    
    public func sortedBy(sortingBy : SortField)->[Contact] {
        switch sortingBy {
        case .firstName :
            return contacts.sorted { ($0.firstName + $0.lastName).localizedCaseInsensitiveCompare($1.firstName + $1.lastName) == ComparisonResult.orderedAscending }
        case .lastName :
            return contacts.sorted { ($0.lastName + $0.firstName).localizedCaseInsensitiveCompare($1.lastName + $1.firstName) == ComparisonResult.orderedAscending }
        }
    }
    
    public func add(newContact : Contact){
        contacts.append(newContact)
        NotificationCenter.default.post(name: Notification.Name(PBNotification.ContactListChanged), object: nil)
        save()
    }
    
    public func get(byID contactID : String) -> Contact?{
        let index =  getIndex(contactID: contactID)
        if index == -1{
            return nil
        }else{
            return contacts[index]
        }
    }
    
    public func remove(contactID : String){
        let index = getIndex(contactID: contactID)
        if  index > -1 {
            contacts.remove(at: index)
        }
        NotificationCenter.default.post(name: Notification.Name(PBNotification.ContactListChanged), object: nil)
        save()
    }
    
    public func update(contact : Contact){
        let index = getIndex(contactID: contact.id)
        if index > -1{
            contacts[index] = contact
            NotificationCenter.default.post(name: Notification.Name(PBNotification.ContactChanged), object: nil, userInfo : ["id" : contact.id])
        }else{
            add(newContact: contact)
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
        helper.save(contactArray: contacts)        
    }
    
    public func load(){
        contacts = helper.load()
    }
}
