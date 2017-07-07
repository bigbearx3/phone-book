//
//  NetworkImageAssistent.swift
//  PhoneBook
//

import  UIKit
import Foundation

class NetworkImageAssistent: ImageAssistent{
    private let clientId : String
    private let bearer : String
    private var urlString : String
    private let loadUrlString : String
    private let ext : String
    
    init(clientId : String, bearer : String, urlString : String, loadUrlString : String, ext : String){
        self.clientId = clientId
        self.bearer = bearer
        self.urlString = urlString
        self.loadUrlString = loadUrlString
        self.ext = ext
    }
    
    private func getBoundaryString()-> String{
        return "Boundary-\(NSUUID().uuidString)"        
    }
    
    private func getBody(fileName : String, imgData : Data) -> Data{
        var body = Data()
        let boundary = getBoundaryString()
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: attachment; name=\"image\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imgData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        return body
    }
    
    
    
    
    
    func saveImage(contact : Contact, successCallBack : @escaping (_ : Contact) -> Void){
        guard let imgData = contact.imageData else {return}
        var contact = contact
        var body = Data()
        let defaultSession = URLSession.shared
        var dataTask: URLSessionDataTask?
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: urlString) {
            var request = URLRequest(url: urlComponents.url!)
            let boundary = getBoundaryString()
            request.httpMethod = "POST"
            request.cachePolicy = .reloadIgnoringLocalCacheData
            
            //request.addValue(clientId, forHTTPHeaderField: "Authorization")
            request.addValue(bearer, forHTTPHeaderField: "Authorization")
            
            
            let contentType = "multipart/form-data; boundary=\(boundary)"
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: attachment; name=\"image\"; filename=\"\(contact.id)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(imgData)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            
            request.httpBody = body
            //debugPrint(request.allHTTPHeaderFields as Any)
            dataTask = defaultSession.dataTask(with: request){ data, response, error in
                defer { dataTask = nil }
                debugPrint("---------- Start --------------")
                if let error = error {
                    print(error.localizedDescription + "\n")
                    return
                } else if let response = response as? HTTPURLResponse{
                    debugPrint(response)
                    if response.statusCode == 200{
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]{
                                debugPrint(json)
                                if let status = json["status"] as? Int,
                                    status == 200,
                                    let data = json["data"] as? [String: Any],
                                    let imgId  = data["id"] as? String {
                                    //contact.imageId = imgId
                                    contact.phone = imgId
                                    DispatchQueue.main.async { successCallBack(contact) }
                                    debugPrint("call save contact information")
                                }
                            }
                        }
                        catch {
                            debugPrint("saveImage")
                            print("Error deserializing JSON: \(error)")
                            return                            
                        }
                    }
                    else{
                        print("Error saving image: response.statusCode = \(response.statusCode)")
                        return
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func deleteImage(contact : Contact, successCallBack : @escaping (_ : Contact) -> Void){
        let defaultSession = URLSession.shared
        var dataTask: URLSessionDataTask?
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: urlString) {
            urlComponents.path = "/\(contact.imageId)"
            var request = URLRequest(url: urlComponents.url!)
            request.setValue(bearer, forHTTPHeaderField: "Authorization")
            request.httpMethod = "DELETE"
            request.cachePolicy = .reloadIgnoringLocalCacheData
            dataTask = defaultSession.dataTask(with: request){ data, response, error in
                defer { dataTask = nil }
                if let error = error {
                    print(error.localizedDescription + "\n")
                    return
                } else if let response = response as? HTTPURLResponse{
                    debugPrint(response)
                    if response.statusCode == 200{
                        /*do {
                            debugPrint(response.statusCode)
                            f let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                                debugPrint(json)
                                if let status = json["status"] as? Int,
                                    status == 200 {
                                    //DispatchQueue.main.async { successCallBack(contact) }
                                    print("Image deleted")
                                }
                            }
                            
                        }
                        catch {
                            debugPrint("deleteImage")
                            print("Error deserializing JSON: \(error)")
                            return
                        }*/
                        print("Image \(contact.phone ?? "") deleted")

                    }
                    else{
                        print("Error saving image: response.statusCode = \(response.statusCode)")
                        return
                    }
                }
                //DispatchQueue.main.async { successCallBack(contact) }
                debugPrint("call delete contact information")
            }
            dataTask?.resume()
        }
    }
    
    func updateImage(contact : Contact, successCallBack : @escaping (_ : Contact) -> Void){
        let successFunc = {(updContact : Contact) -> Void in
            self.saveImage(contact : updContact, successCallBack: successCallBack)
        }
        deleteImage(contact: contact, successCallBack: successFunc)
    }
    
    func loadImageData(contact : Contact, successCallBack : @escaping (_ : Contact) -> Void){
        var contact = contact
        if let imgId = contact.phone{
            let fullLoadUrlString  = loadUrlString + imgId + ext
            if let loadUrl = URL(string: fullLoadUrlString)
            {
                do{
                    let imageData = try Data(contentsOf: loadUrl)
                    contact.imageData = imageData
                    successCallBack(contact)
                }catch{
                    print("Error loading  image from URL: \(fullLoadUrlString)")
                    return
                }
            }
        }
    }
    
}
