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
    
    var toggleState = 1
    
    let vc = ViewController()
    
    @IBAction func toggleRiddles(_ sender: Any) {
        let sampleStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let riddleView = sampleStoryBoard.instantiateViewController(withIdentifier: "riddlesViewController") as! ViewController
        self.present(riddleView, animated: true, completion: nil)
    }
    @IBAction func toggleVisibility(_ sender: UIButton) {
        let show = UIImage(named: "eye")
        let hide = UIImage(named: "closed-eye")
        if toggleState == 1 {
            //hide all annotations
            toggleState = 2
            sender.setImage(hide, for: UIControl.State.normal)
            let annotations = mapView.annotations
            for annotation in annotations {
                mapView.view(for: annotation)?.isHidden = true
            }
        }
        else {
            //show all annotations
            toggleState = 1
            sender.setImage(show, for: UIControl.State.normal)
            let annotations = mapView.annotations
            for annotation in annotations {
                mapView.view(for: annotation)?.isHidden = false
            }
        }
    }
    
    var myLocations: [RiddleLocation] = []
    var solvedLocations: [RiddleLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        createUserTrackingButton()
        
        //FIXME: make sure hunt ID is passed in
        let riddleLocations = vc.getRiddleColumn(hId: 1, col: "location")
        let riddleNames = vc.getRiddleColumn(hId: 1, col: "answer")
        
        for index in 1...riddleLocations.count-1 {
            let lat = Double(riddleLocations[index].components(separatedBy: ", ")[0])
            let long = Double(riddleLocations[index].components(separatedBy: ", ")[1])
            myLocations.append(RiddleLocation(latitude: lat!, longitude: long!, locName: riddleNames[index]))
        }
        
        triggerARView(loc: myLocations[solvedLocations.count])
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
        
        let currentRiddle = myLocations[solvedLocations.count]
        
        let coord = CLLocation(latitude: currentRiddle.latitude, longitude: currentRiddle.longitude)
        let userLoc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        if coord.distance(from: userLoc) < 40 {
            triggerARView(loc: currentRiddle)
        }
        
        // just a demo of this function
        // self.solveLocation(loc: myLocations[0])
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
        solvedLocations.append(loc)
    }
    
    func triggerARView(loc: RiddleLocation) {
        // make ARView pop up
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Riddle Location Found!", message: "You are near a riddle location! Open AR?",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            
            let okButton = UIAlertAction(title: "Yes", style: .default) { _ in
                let sampleStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let ARVC = sampleStoryBoard.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
                self.present(ARVC, animated: true, completion: nil)
            }
            alert.addAction(okButton)
            
            self.present(alert, animated: true)
        }
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

@IBDesignable extension UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}
