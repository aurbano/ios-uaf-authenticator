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
        loadRegistrations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    private func loadRegistrations() {
        ValidRegistrations.reset()
        if let savedRegistrations = getSavedRegistrations() {
            for reg in savedRegistrations {
                ValidRegistrations.addRegistration(registrationToAdd: reg)
            }
        }
    }
    
    private func getSavedRegistrations() -> [Registration]? {
        let savedRegs = NSKeyedUnarchiver.unarchiveObject(withFile: Registration.ArchiveURL.path)
        return savedRegs as? [Registration]
    }

}

    
