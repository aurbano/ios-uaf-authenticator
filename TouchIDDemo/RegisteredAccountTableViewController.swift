//
//  RegisteredAccountTableViewController.swift
//  TouchIDDemo
//
//  Created by Iva on 15/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import UIKit

class RegisteredAccountTableViewController: UITableViewController {
    
    //MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ValidRegistrations.reset()
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedRegistrations = loadRegistrations() {
            for reg in savedRegistrations {
                ValidRegistrations.addRegistration(registrationToAdd: reg)
            }
        }
        else {
            loadSample()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func unwindToRegistrationList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ViewController, let registration = sourceViewController.registration {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {

                ValidRegistrations.registrations[selectedIndexPath.row] = registration
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {

                let newIndexPath = IndexPath(row: ValidRegistrations.items(), section: 0)
                
                ValidRegistrations.addRegistration(registrationToAdd: registration)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveRegistrations()
        }
    }


    func loadSample() {
        let reg1 = Registration(appID: "sample reg", keyTag: "sample reg", url: "sample reg", env: "sample env1", username: "sample1")
        ValidRegistrations.addRegistration(registrationToAdd: reg1)
        
        let reg2 = Registration(appID: "sample appid", keyTag: "sample tag", url: "sample url", env: "sample env2", username: "sample2")
        ValidRegistrations.addRegistration(registrationToAdd: reg2)

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

        cell.envLabel.text = (cell.envLabel.text! + registration.environment)
        cell.username.text = (cell.username.text! + registration.username)

        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ValidRegistrations.deleteRegistration(atIndex: indexPath.row)
            saveRegistrations()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    private func saveRegistrations() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ValidRegistrations.registrations, toFile: Registration.ArchiveURL.path)
        if (isSuccessfulSave) {
            print(ErrorString.Info.regSavedSuccess)
        }
        else {
            print(ErrorString.Info.regSavedFail)
        }
    }
    
    private func loadRegistrations() -> [Registration]? {
//        guard let registrations = NSKeyedUnarchiver.unarchiveObject(withFile: Registration.ArchiveURL.path) as? [Registration] else {
//            print(ErrorString.Info.regLoadFail)
//            return nil
//        }
        let savedRegs = NSKeyedUnarchiver.unarchiveObject(withFile: Registration.ArchiveURL.path)
        return savedRegs as? [Registration]

//        return registrations
    }
}
