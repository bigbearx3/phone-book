//
//  NetworkAsistent.swift
//  PhoneBook
//

import Foundation

class NetworkAsistent{
    private let appID : String
    private let urlString : String
    
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
            guard let url = urlComponents.url else { return}
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            var jsonData : Data
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: converter.convertTo(contact: contact))
            } catch {
                return
            }
            dataTask = defaultSession.dataTask(with: request) { data, response, error in
                defer { dataTask = nil }
                
                if let error = error {
                    errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                    print(errorMessage)
                } else if let response = response as? HTTPURLResponse{
                        debugPrint(request)
                        debugPrint("status \(response.statusCode)")
                        //debugPrint("Contact saved")
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
            //urlComponents.query = "app_id=\(appID)"
            
            guard let url = urlComponents.url else { return}
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            var jsonData : Data
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: converter.convertTo(contact: contact))
            } catch {
                return
            }
            dataTask = defaultSession.dataTask(with: request) { data, response, error in
                defer { dataTask = nil }
                
                if let error = error {
                    errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                    print(errorMessage)
                } else if let response = response as? HTTPURLResponse{
                    debugPrint(request)
                    debugPrint("status \(response.statusCode)")
                    //debugPrint("Contact saved")
                }
            }
            dataTask?.resume()
        }
        
    }
    
    func delele(id : String){
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        var errorMessage = ""
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: urlString) {
            urlComponents.path = "/user/\(id)"
            
            guard let url = urlComponents.url else { return}
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            dataTask = defaultSession.dataTask(with: request) { data, response, error in
                defer { dataTask = nil }
                
                if let error = error {
                    errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                    print(errorMessage)
                } else if let response = response as? HTTPURLResponse{
                    debugPrint(request)
                    debugPrint("status \(response.statusCode)")
                    //debugPrint("Contact saved")
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
            
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { dataTask = nil }
                if let error = error {
                    errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                    print(errorMessage)
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let users = json["users"] as? [[String: Any]] {
                            for user in users {
                                if let contact = converter.convertFrom(rawData: user) {
                                    result.append(contact)
                                }
                            }
                        }
                    } catch {
                        print("Error deserializing JSON: \(error)")
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
}
