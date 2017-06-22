//
//  NSCodingAssistant.swift
//  PhoneBook
//

import Foundation

class NSCodingAssistent : ContactListAssistent{
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
        if let data = (NSKeyedUnarchiver.unarchiveObject(withFile: fileUrl.path) as? [Contact.Coding])?.decoded{
            result = data as! [Contact]
        }
        return result
    }
    
    func save(contactArray : [Contact]) {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent(destinationFile)
        NSKeyedArchiver.archiveRootObject(contactArray.encoded, toFile: fileUrl.path)
    }
}
