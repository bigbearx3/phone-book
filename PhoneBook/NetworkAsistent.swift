//
//  NetworkAsistent.swift
//  PhoneBook
//

import Foundation

class NetworkAsistent{
    private let appID : String
    private let urlString : String
    private let converter : ContactConverter
    
    init(urlString : String, appID : String, converter : ContactConverter){
        self.urlString = urlString
        self.appID = appID
        self.converter = converter
    }
    
    func load(beforeLoad : @escaping ()->Void, afterLoad : @escaping ()->Void) -> [Contact]{
        var result = [Contact]()
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        var errorMessage = ""
        
        
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: urlString) {
            urlComponents.path = "/user/all"
            //urlComponents.query = "app_id=\(appID)"
            
            guard let url = urlComponents.url else { return result}
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { dataTask = nil }
                beforeLoad()
                if let error = error {
                    errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let users = json["users"] as? [[String: Any]] {
                            for user in users {
                                if let contact = self.converter.convertFrom(rawData: user) {
                                    result.append(contact)
                                }
                            }
                        }
                    } catch {
                        print("Error deserializing JSON: \(error)")
                    }
                }
                afterLoad()
                debugPrint(result)
            }
            dataTask?.resume()
        }
        return result
    }
    
}
