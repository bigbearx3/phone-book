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
    
    func load(){
        let defaultSession = URLSession(configuration: .default)
        // 2
        var dataTask: URLSessionDataTask?
        var errorMessage = ""
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: urlString) {
            urlComponents.path = "/user/all"
            //urlComponents.query = "app_id=\(appID)"
            // 3
            guard let url = urlComponents.url else { return }
            // 4
            print("Before dataTask")
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { dataTask = nil }
                // 5
                if let error = error {
                    errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    print(data)
                    //self.updateSearchResults(data)
                    // 6
//                      DispatchQueue.main.async {
//                                            //completion(self.tracks, self.errorMessage)
//                        
//                        print(data)
//                                        }
                }
                print(response)
                if let response = response as? HTTPURLResponse { print(response.statusCode) }
                
            }
            
            dataTask?.resume()
            
        }
        
    }
    
}
