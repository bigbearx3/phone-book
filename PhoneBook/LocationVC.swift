//
//  LocationVC.swift
//  PhoneBook
//

import Foundation

protocol LocationVC{
    func showLocationIn(latitude : Double?, longitude : Double?,  deltaLatitude : Double, deltaLongitude : Double)
    func showMapWithType(mapType : Int)
}
