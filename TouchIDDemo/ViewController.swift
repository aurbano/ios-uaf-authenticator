//
//  ViewController.swift
//  TouchIDDemo
//
//  Created by Iva on 24/07/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import UIKit
import LocalAuthentication
import Foundation
import MapKit
import CoreLocation

class ViewController: UIViewController, UINavigationControllerDelegate {
    
//    var registration: Registration?
    var scannedData: String = ""
//    var locationManager = CLLocationManager.init()

    //MARK: Properties
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var environment: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //        showAlert(latitude: 51.50476244954495, longitude: -0.023882389068603516)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        var overlay = UIView()
        let activityIndicator = UIActivityIndicatorView()
        
        overlay = UIView(frame: self.view.frame)
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.8
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        
        self.view.addSubview(overlay)
        overlay.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()

        let qrScannerVC: QRScannerViewController = segue.source as! QRScannerViewController
//        showAlert(latitude: 51.50476244954495, longitude: -0.023882389068603516)
        scannedData = qrScannerVC.dataCaptured
        Register.sharedInstance.completeRegistration(with: scannedData) { success in
            if (success) {
                activityIndicator.stopAnimating()
                overlay.removeFromSuperview()
                
                let alert = UIAlertController(title: MessageString.Info.regSuccess, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in NSLog("Registration complete alert")}))
                
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: MessageString.Info.regFail, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in NSLog("Registration fail alert")}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
//    @IBAction func unwindToViewControllerFromAlert(segue: UIStoryboardSegue) {
//        let qrScannerVC: AlertViewController = segue.source as! AlertViewController
//    }
    
    
    @IBAction func register(_ sender: UIButton) {
        self.view.endEditing(true)
        var overlay = UIView()
        let activityIndicator = UIActivityIndicatorView()
        
        if (username.text != "" && environment.text != "") {
            overlay = UIView(frame: self.view.frame)
            overlay.backgroundColor = UIColor.black
            overlay.alpha = 0.8
            
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            
            self.view.addSubview(overlay)
            overlay.addSubview(activityIndicator)

            activityIndicator.startAnimating()
            
            let trimmedUsername = username.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedEnv = environment.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            Register.sharedInstance.register(username: trimmedUsername, environment: trimmedEnv) { (success) in
                self.username.text = ""
                self.environment.text = ""
                

                if (success) {
                    activityIndicator.stopAnimating()
                    overlay.removeFromSuperview()

                    let alert = UIAlertController(title: MessageString.Info.regSuccess, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in NSLog("Registration complete alert")}))

                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: MessageString.Info.regFail, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in NSLog("Registration fail alert")}))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func showAlert(latitude: Double, longitude: Double) {
        
        
        let mapView = MKMapView()
//        let locationManager = CLLocationManager.init()
//        locationManager.requestWhenInUseAuthorization()
        
        let alert = UIAlertController(title: "Location", message: "User registering from this location", preferredStyle: .alert)
        

        mapView.mapType = .standard
        mapView.showsBuildings = true
        
//        alert.view.frame.size = CGSize(width: 1000, height: 800)
//        mapView.frame = CGRect(x: 50, y:10, width: alert.view.frame.width * 0.6, height: alert.view.frame.height * 0.3)
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)

        alert.view.addSubview(mapView)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Allow", comment: "Default action"), style: UIAlertActionStyle.cancel, handler: {_ in NSLog("Registration fail alert")}))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Decline", comment: "Default action"), style:UIAlertActionStyle.destructive , handler: {_ in NSLog("Registration fail alert")}))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func addText(field: UILabel, text: String) {
        DispatchQueue.main.async() { field.text?.append(text) }
    }
    
}

    
