//
//  LocationPresenterImpl.swift
//  PhoneBook
//

import Foundation

class LocationPresenterImpl : LocationPresenter {
    private unowned let view: LocationVC
    private let model : ContactList
    private let currentId : String?
    
    required init(view: LocationVC, contactList: ContactList, currentId : String?){
        self.view = view
        self.model = contactList
        self.currentId = currentId
    }
    
    func initView(){
        var latitude : Double? = nil
        var longitude : Double? = nil
        if let id = currentId,
            let contact = model.get(byID: id){
            latitude = contact.latitude
            longitude = contact.longitude
        }
        view.showLocationIn(latitude: latitude, longitude: longitude, deltaLatitude: 0.001, deltaLongitude: 0.001)
    }
    
    func changeMapType(mapType : Int){
        view.showMapWithType(mapType : mapType)
    }
    
}
