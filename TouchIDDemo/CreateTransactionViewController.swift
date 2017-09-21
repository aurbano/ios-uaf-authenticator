//
//  CreateTransactionViewController.swift
//  TouchIDDemo
//
//  Created by Iva on 21/09/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import UIKit

class CreateTransactionViewController: UIViewController {

    @IBOutlet weak var transactionContents: UITextField!
    var selectedReg: Registration?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func initiateTx(_ sender: UIButton) {
        AuthenticateDevice.sharedInstance.initiateTx(data: transactionContents.text!, reg: selectedReg!) { success in
            print(success)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
