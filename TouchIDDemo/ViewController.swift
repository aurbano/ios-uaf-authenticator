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
    
    var scannedData: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
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
                activityIndicator.stopAnimating()
                overlay.removeFromSuperview()

                let alert = UIAlertController(title: MessageString.Info.regFail, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in NSLog("Registration fail alert")}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

    
