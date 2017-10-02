//
//  AlertViewController.swift
//  TouchIDDemo
//
//  Created by Iva on 12/09/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Darwin

class AlertViewController: ViewController {

    var pageIndex: Int = 0
    var coordinates = CLLocationCoordinate2D()
    var company: String!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var alertView: UIView!
//    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var companyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.alertView.center = self.view.center
        showMap(location: coordinates)
        companyLabel.text = MessageString.Labels.content + company

//        let url = URL(string: "https://www.morganstanley.com/")
//        let reqObj = URLRequest(url: url!)
//        webView.loadRequest(reqObj)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMap(location: CLLocationCoordinate2D) {

        mapView.mapType = .standard
        mapView.showsBuildings = true
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    let kCustomURLScheme = "tests://"
    
    func openCustomURLScheme(customURLScheme: String) -> Bool {
        let customURL = URL(string: customURLScheme)!
        if UIApplication.shared.canOpenURL(customURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(customURL)
            } else {
                UIApplication.shared.openURL(customURL)
            }
            return true
        }
        return false
    }
   
    
    @IBAction func declineButtonClick(_ sender: UIButton) {
        let index = self.pageIndex
        let tx = PendingTransactions.getTransaction(atIndex: index)
        guard let reg = ValidRegistrations.getRegistrationFrom(registrationId: tx.registrationId!) else {
            return
        }
        
        var overlay = UIView()
        let activityIndicator = UIActivityIndicatorView()
        
        overlay = UIView(frame: self.view.frame)
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.8
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        overlay.layer.zPosition = 0
        self.view.addSubview(overlay)
        overlay.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()

        AuthenticateDevice.sharedInstance.respondTx(response: MessageString.Server.declinedTx, challenge: tx.challenge!, registration: reg) { success in
            
            activityIndicator.stopAnimating()
            overlay.removeFromSuperview()

            if (success) {
                PendingTransactions.removeTransaction(atIndex: index)
                self.dismiss(animated: true, completion: nil)

                if(PendingTransactions.switched == tx.challenge) {
                    if (self.openCustomURLScheme(customURLScheme: self.kCustomURLScheme)) {
                        PendingTransactions.switched = String()
                        print("app opened successfully")
                    }
                    else {
                        PendingTransactions.switched = String()
                        print("unable to open another app")
                    }
                }
                else {
                    self.presentAlert(message: MessageString.Info.txSuccess)
                }
            }
            else {
                self.presentAlert(message: MessageString.Info.txFail)
            }
        }
    }
    
    @IBAction func signButtonClick(_ sender: UIButton) {
        let index = self.pageIndex
        let tx = PendingTransactions.getTransaction(atIndex: index)
        guard let reg = ValidRegistrations.getRegistrationFrom(registrationId: tx.registrationId!) else {
            return
        }
        
        var overlay = UIView()
        let activityIndicator = UIActivityIndicatorView()
        
        overlay = UIView(frame: self.view.frame)
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.8
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        overlay.layer.zPosition = 0
        self.view.addSubview(overlay)
        overlay.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()

        AuthenticateDevice.sharedInstance.respondTx(response: MessageString.Server.signedTx, challenge: tx.challenge!, registration: reg) { success in
            
            activityIndicator.stopAnimating()
            overlay.removeFromSuperview()
            if (success) {
                PendingTransactions.removeTransaction(atIndex: index)
                self.dismiss(animated: true, completion: nil)

                if(PendingTransactions.switched == tx.challenge) {
                    if (self.openCustomURLScheme(customURLScheme: self.kCustomURLScheme)) {
                        PendingTransactions.switched = String()
                        print("app opened successfully")
                    }
                    else {
                        PendingTransactions.switched = String()
                        print("unable to open another app")
                    }
                }
                else {
                    self.presentAlert(message: MessageString.Info.txSuccess)
                }
            }
            else {
                self.presentAlert(message: MessageString.Info.txFail)
            }
        }
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {(alert: UIAlertAction!) in
            NSLog(message)
        }))
        self.present(alert, animated: true, completion: nil)

    }
}
