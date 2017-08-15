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
    
    
    //MARK: Properties
    
    @IBOutlet weak var infoTextLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
//
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showRegistrations(_ sender: UIButton) {
//        performSegue(withIdentifier: "registrations", sender: self)
    }
    @IBAction func register(_ sender: UIButton) {
        
        RegisterDevice.sharedInstance.register()
        
//        if (RegisterDevice.sharedInstance.register()) {
//            addText(field: infoTextLabel, text: "Successful registration")
//        }
    }
    
    //MARK: Helper methods
    
    func addText(field: UILabel, text: String) {
        DispatchQueue.main.async() { field.text?.append(text) }
    }
    
}

    
