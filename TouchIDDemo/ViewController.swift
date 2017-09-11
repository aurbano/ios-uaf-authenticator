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
    //MARK: Properties
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var environment: UITextField!
    @IBOutlet weak var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        if (username.text != "" && environment.text != "") {
            let trimmedUsername = username.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedEnv = environment.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            RegisterDevice.sharedInstance.register(username: trimmedUsername, environment: trimmedEnv)
            username.text = ""
            environment.text = ""
            
            overlay = UIView(frame: view.frame)
            overlay.backgroundColor = UIColor.black
            overlay.alpha = 0.8
            
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
//            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view.addSubview(overlay)
            overlay.addSubview(activityIndicator)

            
            activityIndicator.startAnimating()
            
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                
                self.activityIndicator.stopAnimating()
                self.overlay.removeFromSuperview()
                let alert = UIAlertController(title: "Registration", message: "Registration successful", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in NSLog("Registration complete alert")}))
                self.present(alert, animated: true, completion: nil)

            }
        }
    }
    
    //MARK: Helper methods
    
    func addText(field: UILabel, text: String) {
        DispatchQueue.main.async() { field.text?.append(text) }
    }
    
}

    
