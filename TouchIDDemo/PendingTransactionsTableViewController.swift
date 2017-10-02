//
//  PendingTransactionsTableViewController
//  TouchIDDemo
//
//  Created by Iva on 15/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import UIKit

class PendingTransactionsTableViewController: UITableViewController {
    
    //MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 15.0/255.0, green: 142.0/255.0, blue: 199.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        self.refreshControl?.addTarget(self, action: #selector(PendingTransactionsTableViewController.refresh), for: UIControlEvents.valueChanged)

        tableView.addSubview(refreshControl!)
    }
    
    func loadList() {
        self.tableView.reloadData()
    }
    
    func refresh() {
        queryTransactions()
        refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        queryTransactions()
        self.tableView.reloadData()
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
        return PendingTransactions.items()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PendingTransactionsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PendingTransactionsTableViewCell else {
            fatalError("The dequeued cell is not an instance of PendingTransactionsTableViewCell.")
        }
        
        let transaction = PendingTransactions.getTransaction(atIndex: indexPath.row)
        
        cell.companyLabel.text = ("Contents: " + transaction.contents!)
//        cell.valueLabel.text = ("Value: " + String(transaction.value!) + transaction.currency!.rawValue)
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
    
    
    /*
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
    */
    
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
        super.prepare(for: segue, sender: sender)
        var index = -1

        switch(segue.identifier ?? "") {
        case "openPageView":
            guard let pageViewController = segue.destination as? TransactionsPageViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            if let selectedTransactionCell = sender as? PendingTransactionsTableViewCell {
                guard let indexPath = tableView.indexPath(for: selectedTransactionCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                index = indexPath.row
            }
            else if PendingTransactions.items() == 1 {
                index = 0
            }
            if (index != -1) {
                pageViewController.page = index
            }
            else {
                fatalError("Unexpected sender cell")
            }
            
//        case "openPageViewSingleTx":
//            guard let pageViewController = segue.destination as? TransactionsPageViewController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//
//            pageViewController.page = 0

        default:
            fatalError("Unexpected segue indentifier: \(String(describing: segue.identifier))")
        }
    }
    
//    @IBAction func unwindFromPageViewDecline(segue: UIStoryboardSegue) {
//        print("decline")
//        self.tableView.reloadData()
//    }
//
//    @IBAction func unwindFromPageViewSign(segue: UIStoryboardSegue) {
//        print("sign")
//        self.tableView.reloadData()
//    }
 
    func queryTransactions() {
        PendingTransactions.clear()
        AuthenticateDevice.sharedInstance.getPendingTransactions() { success in
            if (success) {
                self.tableView.reloadData()
            }
        }
    }
}
