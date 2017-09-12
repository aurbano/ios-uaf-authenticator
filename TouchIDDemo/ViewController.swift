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

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    var overlay = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var registration: Registration?
    var scannedData: String?
    //MARK: Properties
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var environment: UITextField!
    @IBOutlet weak var infoLabel: UILabel!

    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        let qrScannerVC: QRScannerViewController = segue.source as! QRScannerViewController
        scannedData = qrScannerVC.dataCaptured
        print(scannedData)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        self.view.endEditing(true)

        if (username.text != "" && environment.text != "") {
            self.overlay = UIView(frame: self.view.frame)
            self.overlay.backgroundColor = UIColor.black
            self.overlay.alpha = 0.8
            
            self.activityIndicator.center = self.view.center
            self.activityIndicator.hidesWhenStopped = true
            
            self.view.addSubview(self.overlay)
            self.overlay.addSubview(self.activityIndicator)

            self.activityIndicator.startAnimating()
            
            let trimmedUsername = username.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedEnv = environment.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            Register.sharedInstance.register(username: trimmedUsername, environment: trimmedEnv) { (success) in
                self.username.text = ""
                self.environment.text = ""
                
//                let deadline = DispatchTime.now() + 1
//                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    
                    self.activityIndicator.stopAnimating()
                    self.overlay.removeFromSuperview()

                    if (success) {
                        let alert = UIAlertController(title: MessageString.Info.regSuccess, message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in NSLog("Registration complete alert")}))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        let alert = UIAlertController(title: MessageString.Info.regFail, message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in NSLog("Registration fail alert")}))
                        self.present(alert, animated: true, completion: nil)
                    }
//                }
            }
        }
    }
    
    //MARK: Helper methods
    
    func addText(field: UILabel, text: String) {
        DispatchQueue.main.async() { field.text?.append(text) }
    }
    
}

    
