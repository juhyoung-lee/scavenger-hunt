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

            let annotation = MKPointAnnotation()
            annotation.coordinate = locValue
            annotation.title = "User Location"
            annotation.subtitle = "current location"
            mapView.addAnnotation(annotation)
        
            self.solveLocation(loc: myLocations[0])
    }
    
    func solveLocation(loc: RiddleLocation) {
        let annotation = MKPointAnnotation()
        let locValue = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
        annotation.coordinate = locValue
        annotation.title = loc.locName
        mapView.addAnnotation(annotation)
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
