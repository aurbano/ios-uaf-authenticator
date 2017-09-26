//
//  RegisteredAccountTableViewController.swift
//  TouchIDDemo
//
//  Created by Iva on 15/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import UIKit
import Registrations

class RegisteredAccountTableViewController: UITableViewController {
    
    //MARK: Properties
    var scannedData: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(RegisteredAccountTableViewController.refresh), for: UIControlEvents.valueChanged)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }

    func loadList() {
        self.tableView.reloadData()
    }
    
    func refresh() {
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func addSample() {
        let registration1 = Registrations.Registration(registrationId: "regID1",
                                         appID: "appID1",
                                         keyTag: "keyTag1",
                                         url: "url",
                                         env: "dev",
                                         username: "iva",
                                         keyID: Array<UInt8>())
        
        let registration2 = Registrations.Registration(registrationId: "regID2",
                                         appID: "appID2",
                                         keyTag: "keyTag2",
                                         url: "url",
                                         env: "qa",
                                         username: "iva",
                                         keyID: Array<UInt8>())

        ValidRegistrations.addRegistration(registrationToAdd: registration1)
        ValidRegistrations.addRegistration(registrationToAdd: registration2)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ValidRegistrations.items()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RegisteredAccountTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RegisteredAccountTableViewCell else {
            fatalError("The dequeued cell is not an instance of RegisteredAccountTableViewCell.")
        }
        
        let registration = ValidRegistrations.registrations[indexPath.row]

        cell.environment.text = ("Environment: " + registration.environment)
        cell.username.text = ("Username: " + registration.username)
        cell.index = indexPath.row

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        self.performSegue(withIdentifier: "QRScanner", sender: cell)
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (ValidRegistrations.deleteRegistration(atIndex: indexPath.row)) {
                saveRegistrations()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "InitiateTransaction") {
            guard let initiateTxViewController = segue.destination as? CreateTransactionViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedRegCell = sender as? RegisteredAccountTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }

            guard let indexPath = tableView.indexPath(for: selectedRegCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedReg = ValidRegistrations.registrations[indexPath.row]
            initiateTxViewController.selectedReg = selectedReg
        }
    }
    
        
    @IBAction func unwindToRegistrationsTableView(segue: UIStoryboardSegue) {
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
                
                let alert = UIAlertController(title: MessageString.Info.regSuccess, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {(alert: UIAlertAction!) in
                        NSLog("Registration success alert")
                        activityIndicator.stopAnimating()
                        overlay.removeFromSuperview()
                }))
                
                self.present(alert, animated: true, completion: nil)

                self.tableView.reloadData()
            }
            else {
                
                let alert = UIAlertController(title: MessageString.Info.regFail, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {(alert: UIAlertAction!) in
                    NSLog("Registration success alert")
                    activityIndicator.stopAnimating()
                    overlay.removeFromSuperview()
                }))
                self.present(alert, animated: true, completion: nil)

            }
        }
    }
    private func saveRegistrations() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ValidRegistrations.registrations, toFile: Registration.ArchiveURL.path)
        if (isSuccessfulSave) {
            print(MessageString.Info.regSavedSuccess)
        }
        else {
            print(MessageString.Info.regSavedFail)
        }
    }
}
