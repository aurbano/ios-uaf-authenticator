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
        guard let reg = ValidRegistrations.instance.getRegistrationFrom(registrationId: tx.registrationId!) else {
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

                if(PendingTransactions.switchedTxChallenge == tx.challenge) {
                    if (self.openCustomURLScheme(customURLScheme: self.kCustomURLScheme + "challenge=" + tx.challenge! + "&" + "registrationId=" + reg.registrationId)) {
                        PendingTransactions.switchedTxChallenge = String()
                        self.dismiss(animated: true, completion: nil)
                        print("app opened successfully")
                    }
                    else {
                        // tx success, can't open another app
                        PendingTransactions.switchedTxChallenge = String()
                        let alert = UIAlertController(title: MessageString.Info.txSuccess, message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {(alert: UIAlertAction!) in
                            NSLog(MessageString.Info.txSuccess)
                            self.performSegue(withIdentifier: "returnFromTxPage", sender: self)
                        }))
                        self.present(alert, animated: true, completion: nil)

                        print("unable to open another app")
                    }
                }
                else {
                    // tx success, no context-switch
                    let alert = UIAlertController(title: MessageString.Info.txSuccess, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {(alert: UIAlertAction!) in
                        NSLog(MessageString.Info.txSuccess)
                        self.performSegue(withIdentifier: "returnFromTxPage", sender: self)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                // tx fail
                let alert = UIAlertController(title: MessageString.Info.txFail, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {(alert: UIAlertAction!) in
                    NSLog(MessageString.Info.txFail)
                    self.performSegue(withIdentifier: "returnFromTxPage", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signButtonClick(_ sender: UIButton) {
        let index = self.pageIndex
        let tx = PendingTransactions.getTransaction(atIndex: index)
        guard let reg = ValidRegistrations.instance.getRegistrationFrom(registrationId: tx.registrationId!) else {
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

                if(PendingTransactions.switchedTxChallenge == tx.challenge) {
                    if (self.openCustomURLScheme(customURLScheme: self.kCustomURLScheme + "challenge=" + tx.challenge! + "&" + "registrationId=" + reg.registrationId)) {
                        PendingTransactions.switchedTxChallenge = String()
                        self.dismiss(animated: true, completion: nil)
                        print("app opened successfully")
                    }
                    else {
                        PendingTransactions.switchedTxChallenge = String()
                        
                        // successsful tx, can't open the other app
                        let alert = UIAlertController(title: MessageString.Info.txSuccess, message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {(alert: UIAlertAction!) in
                            NSLog(MessageString.Info.txSuccess)
                            self.performSegue(withIdentifier: "returnFromTxPage", sender: self)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        print("unable to open another app")
                    }
                }
                else {
                    // tx  success, no context-switch
                    let alert = UIAlertController(title: MessageString.Info.txSuccess, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {(alert: UIAlertAction!) in
                        NSLog(MessageString.Info.txSuccess)
                        self.performSegue(withIdentifier: "returnFromTxPage", sender: self)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                // tx fail
                let alert = UIAlertController(title: MessageString.Info.txFail, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {(alert: UIAlertAction!) in
                    NSLog(MessageString.Info.txFail)
                    self.performSegue(withIdentifier: "returnFromTxPage", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)

            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != alertView {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
