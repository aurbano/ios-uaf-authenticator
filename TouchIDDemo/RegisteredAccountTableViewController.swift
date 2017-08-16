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
    
    var registrations = [Registration]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedRegistrations = loadRegistrations() {
            registrations += savedRegistrations
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

        let newIndexPath = IndexPath(row: registrations.count, section: 0)
        
        registrations.append(registration)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }


    func loadSample() {
        let reg1 = Registration(appID: "sample reg", keyTag: "sample reg", url: "sample reg", env: "uat", username: "iva nikolaeva")
        
        registrations += [reg1]
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
        return registrations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RegisteredAccountTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RegisteredAccountTableViewCell else {
            fatalError("The dequeued cell is not an instance of RegisteredAccountTableViewCell.")
        }
        
        let registration = registrations[indexPath.row]

        cell.envLabel.text = (cell.envLabel.text! + registration.environment)
        cell.username.text = (cell.username.text! + registration.username)

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveRegistration()
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
    
    
    func saveRegistration() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(registrations, toFile: Registration.ArchiveURL.path)
        if (isSuccessfulSave) {
            print("Registration data saved successfully")
        }
        else {
            print("failed to save registration data")
        }
    }
    
    private func loadRegistrations() -> [Registration]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Registration.ArchiveURL.path) as? [Registration]
    }
}
