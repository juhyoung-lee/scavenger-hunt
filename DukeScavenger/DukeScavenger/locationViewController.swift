//
//  locationViewController.swift
//  DukeScavenger
//
//  Created by RJ  Schreck on 4/1/21.
//

import UIKit
import CoreLocation
import MapKit

class locationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    // tentatively just here for testing
    let myLocations: [RiddleLocation] = [RiddleLocation(latitude: 35.99911, longitude: -78.92904, locName: "Nasher Museum"), RiddleLocation(latitude: 35.99705, longitude: -78.94258, locName: "Cameron Stadium"), RiddleLocation(latitude: 36.00668, longitude: -78.91326, locName: "Duke Coffeehouse")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        createUserTrackingButton()
        // Do any additional setup after loading the view.
    }
    //Mark: CoreLocation Methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways{
            locationManager.startUpdatingLocation()
        }
        if status == .notDetermined || status == .denied {
            print("app cannot be used without location authorization")
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    var regionHasBeenCentered = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate

        mapView.mapType = MKMapType.standard

        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: locValue, span: span)
    
        // allows user to scroll around without snapping back to location.
        if !regionHasBeenCentered {
            mapView.setRegion(region, animated: true)
            regionHasBeenCentered = true
        }

//            let annotation = MKPointAnnotation()
//            annotation.coordinate = locValue
//            annotation.title = "User Location"
//            annotation.subtitle = "current location"
//            mapView.addAnnotation(annotation)
        
        for location in myLocations {
            let coord = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let userLoc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            
            if coord.distance(from: userLoc) < 40 {
                triggerARView(loc: location)
            }
        }
        
        // just a demo of this function
        self.solveLocation(loc: myLocations[0])
    }
    
    func createUserTrackingButton() {
        mapView.showsUserLocation = true
        
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 10.0
        button.layer.masksToBounds = false
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        let scale = MKScaleView(mapView: mapView)
        scale.legendAlignment = .trailing
        scale.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scale)
        
        NSLayoutConstraint.activate([button.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                                     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                                     scale.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10),
                                     scale.centerYAnchor.constraint(equalTo: button.centerYAnchor)])
    }
    
    func solveLocation(loc: RiddleLocation) {
        let annotation = MKPointAnnotation()
        let locValue = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
        annotation.coordinate = locValue
        annotation.title = loc.locName
        mapView.addAnnotation(annotation)
    }
    
    func triggerARView(loc: RiddleLocation) {
        // make ARView pop up
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
