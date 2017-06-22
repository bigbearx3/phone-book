//
//  LocationVCImpl.swift
//  PhoneBook
//

import UIKit
import MapKit
import CoreLocation

class LocationVCImpl: UIViewController, MKMapViewDelegate, LocationVC {
    
    @IBOutlet weak var mapView: MKMapView!
    var presenter : LocationPresenter!
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        presenter.initView()        
        
//        locationManager.requestWhenInUseAuthorization()
//        
//        mapView.mapType = .standard
//        mapView.showsUserLocation = true
//        mapView.showsScale = true
//        mapView.showsCompass = true
//        
//        let span = MKCoordinateSpan.init(latitudeDelta: 0.001, longitudeDelta: 0.001)
//        let region = MKCoordinateRegion.init(center: (locationManager.location?.coordinate)!, span: span)
//        mapView.setRegion(region, animated: true)
        //mapView.center.init()
        
        //mapView.delegate = self
//        mapView.showsScale = true
//        mapView.showsCompass = true
//        mapView.showsTraffic = true
//        mapView.mapType = MKMapType.hybrid
//        
//        
//        let sourceLocation = CLLocationCoordinate2D(latitude: 49.233593, longitude: 28.469321)
//        let destinationLocation = CLLocationCoordinate2D(latitude: 50.4449071, longitude: 30.521182)
//        
//        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
//        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
//        
//        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//        
//        // 5.
//        let sourceAnnotation = MKPointAnnotation()
//        sourceAnnotation.title = "I'm here"
//        
//        if let location = sourcePlacemark.location {
//            sourceAnnotation.coordinate = location.coordinate
//        }
//        
//        
//        let destinationAnnotation = MKPointAnnotation()
//        destinationAnnotation.title = "I'm going there"
//        
//        if let location = destinationPlacemark.location {
//            destinationAnnotation.coordinate = location.coordinate
//        }
//        
//        // 6.
//        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
//        
//        // 7.
//        let directionRequest = MKDirectionsRequest()
//        directionRequest.source = sourceMapItem
//        directionRequest.destination = destinationMapItem
//        directionRequest.transportType = .automobile
//        
//        // Calculate the direction
//        let directions = MKDirections(request: directionRequest)
//        
//        // 8.
//        directions.calculate {
//            (response, error) -> Void in
//            
//            guard let response = response else {
//                if let error = error {
//                    print("Error: \(error)")
//                }
//                
//                return
//            }
//            
//            let route = response.routes[0]
//            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
//            
//            let rect = route.polyline.boundingMapRect
//            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
//
//        // Do any additional setup after loading the view.
//        }
    }
    
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        presenter.changeMapType(mapType: sender.selectedSegmentIndex)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.setCenter(userLocation.coordinate, animated: true)
    }
    
    func showLocationIn(latitude : Double?, longitude : Double?,  deltaLatitude : Double, deltaLongitude : Double){
        let span = MKCoordinateSpan.init(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
        let region : MKCoordinateRegion
        if let curentLongitude = longitude,
            let curentLatitude = latitude{
            let center = CLLocationCoordinate2D(latitude: curentLongitude, longitude: curentLatitude)
            region = MKCoordinateRegion.init(center: center, span: span)
        }else{
            region = MKCoordinateRegion.init(center: (locationManager.location?.coordinate)!, span: span)
        }
        mapView.setRegion(region, animated: true)
    }
    
    func showMapWithType(mapType : Int){
        switch UInt(mapType) {
        case MKMapType.standard.rawValue:
            mapView.mapType = .standard
        case MKMapType.satellite.rawValue:
            mapView.mapType = .satellite
        case MKMapType.hybrid.rawValue:
            mapView.mapType = .hybrid
        default:
            mapView.mapType = .standard
        }
    }
}
