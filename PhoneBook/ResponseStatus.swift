//
//  ResponseStatus.swift
//  PhoneBook
//

import Foundation

enum ResponseStatus : String{
    case status200 = "Ok"
    case status201 = "Created"
    case status400 = "Bad Request"
    case status404 = "Not Found"
    case status500 = "Internal Server Error"
}
