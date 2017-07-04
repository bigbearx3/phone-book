//
//  NetworkImageListAssistent.swift
//  PhoneBook
//

import Foundation

class NetworkImageListAssistent: ImageListAssistent{
    private var imageList = [String : Data]()
    private var defaulImageData : Data? = nil
    private let clientId : String
    private let bearer : String
    private let url : URL
    weak var  delegate : ImageListAssistentDelegate!
    
    init(clientId : String, bearer : String, url : URL){
        self.clientId = clientId
        self.bearer = bearer
        self.url = url        
    }
    
    private func getBoundaryString()-> String{
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    private func getBody(fileName : String, imgData : Data) -> Data{
        var body = Data()
        let boundary = getBoundaryString()
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: attachment; name=\"image\"; filename=\".\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imgData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        return body
    }
    
    
    func getImage(imgId : String) -> Data?{return defaulImageData}
    
    
    func saveImage(imgData : Data){
        var urlString = "https://api.imgur.com/3/image"
        
        let defaultSession = URLSession.shared
        var dataTask: URLSessionDataTask?
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: urlString) {
            var request = URLRequest(url: url)
            let boundary = getBoundaryString()
            request.setValue(clientId, forHTTPHeaderField: "Authorization")
            request.setValue(bearer, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.cachePolicy = .reloadIgnoringLocalCacheData
            
            let contentType = "multipart/form-data; boundary=\(boundary)"
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = getBody(fileName: "mypicture", imgData: imgData)
            
            dataTask = defaultSession.dataTask(with: request){ data, response, error in
                defer { dataTask = nil }
                if let error = error {
                    print(error.localizedDescription + "\n")
                    self.delegate.failLoad()
                    return
                } else if let response = response as? HTTPURLResponse{
                    debugPrint(response)
                    if response.statusCode == 200{
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                                if let status = json["status"] as? Int,
                                    status == 200,
                                    let data = json["data"] as? [String: Any],
                                    let imgId  = data["id"] as? String {
                                        self.imageList[imgId] = imgData
                                        self.delegate.successLoad(imgId  : imgId)
                                }
                            }
                        }
                        catch {
                            print("Error deserializing JSON: \(error)")
                            self.delegate.failLoad()
                            return                            
                        }
                        
                    }
                    else{
                        print("Error saving image: response.statusCode = \(response.statusCode)")
                        self.delegate.failLoad()
                        return
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    
    func deleteImage(imgId : String){}
    func updateImage(imgId : String, imgData : Data){}
    
    
    
}
