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
import Registrations

class InitialViewController: UIViewController, UINavigationControllerDelegate {
    
    var scannedData: String = ""

    @IBOutlet weak var msauthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 44.0/255.0, green: 152.0/255.0, blue: 128.0/255.0, alpha: 1)
        msauthLabel.textColor = UIColor(red: 44.0/255.0, green: 152.0/255.0, blue: 128.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        
//                let url = URL(string: "https://www.morganstanley.com/")
//                let reqObj = URLRequest(url: url!)
//                webView.loadRequest(reqObj)

        // Do any additional setup after loading the view, typically from a nib.
        loadRegistrations()
        print(ValidRegistrations.instance.items())
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute  : {
            self.performSegue(withIdentifier: "openViews", sender: self)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadRegistrations() {
        ValidRegistrations.instance.reset()
        if let savedRegistrations = getSavedRegistrations() {
            for reg in savedRegistrations {
                ValidRegistrations.instance.addRegistration(registrationToAdd: reg)
            }
        }
    }
    
    private func getSavedRegistrations() -> [Registrations.Registration]? {
        //        let savedRegs = NSKeyedUnarchiver.unarchiveObject(withFile: Registration.ArchiveURL.path)
        //        return savedRegs as? [Registration]
        NSKeyedUnarchiver.setClass(Registration.self, forClassName: "Registration")
        if(ValidRegistrations.instance.userDefaults?.object(forKey: "registrations") == nil) {
            print("rr" + ValidRegistrations.instance.random)
            return nil
        }
        let decoded = ValidRegistrations.instance.userDefaults?.object(forKey: "registrations") as! Data
        let decodedRegs = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Registrations.Registration]
        return decodedRegs
        
    }

}

    
