//
//  LocationVC.swift
//  PhoneBook
//

import Foundation

protocol LocationVC : class{
    func showLocationIn(latitude : Double?, longitude : Double?,  deltaLatitude : Double, deltaLongitude : Double)
    func showMapWithType(mapType : Int)   
}
