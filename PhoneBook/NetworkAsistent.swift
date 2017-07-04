//
//  NetworkAsistent.swift
//  PhoneBook
//

import Foundation

class NetworkAsistent : ContactListAssistent{
    private let appID : String
    private let urlString : String
    weak var delegate : AsistentDelegate!
    
    init(urlString : String, appID : String){
        self.urlString = urlString
        self.appID = appID
    }
    
    func save(contact : Contact){
        let converter = ContactConverter(appId: appID, nameAppId: "appid", nameId: "user_id", nameFirstName: "first_name", nameLastName: "last_name", nameEmail: "email", namePhone: "phone_number", nameLatitude: "lat", nameLongidude: "lon")
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        var errorMessage = ""
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: urlString) {
            urlComponents.path = "/user"
            urlComponents.query = "app_id=\(appID)"
            guard let url = urlComponents.url else {
                DispatchQueue.main.async { self.delegate.failSave() }
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: converter.convertTo(contact: contact))
            } catch {
                print("Error serializing JSON: \(converter.convertTo(contact: contact))")
                DispatchQueue.main.async { self.delegate.failSave() }
                return
            }
            dataTask = defaultSession.dataTask(with: request) { data, response, error in
                defer { dataTask = nil }
                if let error = error {
                    print(error.localizedDescription + "\n")
                    DispatchQueue.main.async { self.delegate.failSave() }
                } else if let response = response as? HTTPURLResponse{
                    if response.statusCode == 201{
                        DispatchQueue.main.async { self.delegate.successSave(newContact: contact) }
                    }else{
                        print("Error saving: response.statusCode = \(response.statusCode)")
                        DispatchQueue.main.async { self.delegate.failSave() }
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func update(contact : Contact){
        let converter = ContactConverter(appId: appID, nameAppId: "appid", nameId: "user_id", nameFirstName: "first_name", nameLastName: "last_name", nameEmail: "email", namePhone: "phone_number", nameLatitude: "lat", nameLongidude: "lon")
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        var errorMessage = ""
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: urlString) {
            urlComponents.path = "/user/\(contact.id)"
            guard let url = urlComponents.url else {
                DispatchQueue.main.async { self.delegate.failUpdate() }
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: converter.convertTo(contact: contact))
            } catch {
                print("Error serializing JSON: \(converter.convertTo(contact: contact))")
                DispatchQueue.main.async { self.delegate.failUpdate() }
                return
            }
            dataTask = defaultSession.dataTask(with: request) { data, response, error in
                defer { dataTask = nil }
                if let error = error {
                    print(error.localizedDescription + "\n")
                    DispatchQueue.main.async { self.delegate.failUpdate() }
                } else if let response = response as? HTTPURLResponse{
                    if response.statusCode == 200{
                        DispatchQueue.main.async { self.delegate.successUpdate(contact : contact) }
                    }else{
                        print("Error updating: response.statusCode = \(response.statusCode)")
                        DispatchQueue.main.async { self.delegate.failUpdate() }
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func delete(contactId : String){
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        var errorMessage = ""
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: urlString) {
            urlComponents.path = "/user/\(contactId)"
            guard let url = urlComponents.url else {
                DispatchQueue.main.async { self.delegate.failDelete() }
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            dataTask = defaultSession.dataTask(with: request) { data, response, error in
                defer { dataTask = nil }
                if let error = error {
                    print(error.localizedDescription + "\n")
                    DispatchQueue.main.async { self.delegate.failDelete() }
                } else if let response = response as? HTTPURLResponse{
                    if response.statusCode == 200{
                        DispatchQueue.main.async { self.delegate.successDelete(contactID : contactId) }
                    }else{
                        print("Error deleting: response.statusCode = \(response.statusCode)")
                        DispatchQueue.main.async { self.delegate.failDelete() }
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func load(){
        let converter = ContactConverter(appId: appID, nameAppId: "appid", nameId: "userid", nameFirstName: "firstname", nameLastName: "lastname", nameEmail: "email", namePhone: "phonenumber", nameLatitude: "lat", nameLongidude: "lon")
        var result = [Contact]()
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        var errorMessage = ""
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: urlString) {
            urlComponents.path = "/user"
            urlComponents.query = "app_id=\(appID)"
            guard let url = urlComponents.url else { self.delegate.failLoad() ; return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { dataTask = nil }
                if let error = error {
                    print(error.localizedDescription + "\n")
                    DispatchQueue.main.async { self.delegate.failLoad() }
                } else if let data = data,
                    let response = response as? HTTPURLResponse{
                    if response.statusCode == 200{
                        do {                            
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let users = json["users"] as? [[String: Any]] {
                                for user in users {
                                    if let contact = converter.convertFrom(rawData: user) {
                                        result.append(contact)
                                    }
                                }
                                DispatchQueue.main.async { self.delegate.successLoad(contacts: result) }
                            }
                        } catch {
                            print("Error deserializing JSON: \(error)")
                            DispatchQueue.main.async { self.delegate.failLoad() }
                            return
                        }
                    }else{
                        DispatchQueue.main.async { self.delegate.failLoad() }
                        print("Error loading: response.statusCode = \(response.statusCode)")
                    }
                }
            }
            dataTask?.resume()
        }
    }
}


extension Data {
    mutating func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
