//
//  Contacts.swift
//  ContactList
//

import Foundation

enum SortType : Int{
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
    
    func toString() -> String {
        switch self {
        case .firstName: return "Last Name"
        case .lastName: return "First Name"
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
            let email     = userInfo["email"]    as? String{
            let phone  = userInfo["phone"] as? String
            let imageData = userInfo["imageData"]    as? Data
            let latitude  = userInfo["latitude"]    as? Double
            let longitude     = userInfo["longitude"]    as? Double
            add(newContact: Contact(firstName : firstName, lastName : lastName, email : email, phone : phone, imageData : imageData, latitude : latitude, longitude : longitude))
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
    
    public func sortedBy(sortingBy : SortType)->[Contact] {
        switch sortingBy {
        case .firstName :
            return contacts.sorted { ($0.firstName + " " + $0.lastName).localizedCaseInsensitiveCompare($1.firstName + " " + $1.lastName) == ComparisonResult.orderedAscending }
        case .lastName :
            return contacts.sorted { ($0.lastName + " " + $0.firstName).localizedCaseInsensitiveCompare($1.lastName +  " " + $1.firstName) == ComparisonResult.orderedAscending }
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
        //delete(contactId : contactID)
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
    
    public func save(){        
        helper.save(contactArray: contacts)
    }
    
    public func load(){
        contacts = helper.load()
    }
}
