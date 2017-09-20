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
        self.refreshControl?.addTarget(self, action: #selector(PendingTransactionsTableViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadList),
                                               name:Notification.Name("UPDATED_DATA"),
                                               object: nil)
        
        
        //Pull pending transactions
//        if (PendingTransactions.items() == 0) {
//            self.performSegue(withIdentifier: "noRegistrationsSegue", sender: self)
//        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadList() {
        self.tableView.reloadData()
    }
    
    func refresh() {
        AuthenticateDevice.sharedInstance.getPendingTransactions()
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func addSample() {
        let transaction1 = Transaction(value: 100000,
                                       currency: Currency.gbp,
                                       date: "18/09/17",
                                       company: "Apple",
                                       location: [51.50476244954495, -0.023882389068603516])
        
        let transaction2 = Transaction(value: 5000,
                                       currency: Currency.usd,
                                       date: "18/09/17",
                                       company: "Microsoft",
                                       location: [51.5030154, -0.022172700000055556])
        
        PendingTransactions.addTransaction(t: transaction1)
        PendingTransactions.addTransaction(t: transaction2)
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
        
        cell.companyLabel.text = ("Company: " + transaction.company)
        cell.valueLabel.text = ("Value: " + String(transaction.value) + transaction.currency.rawValue)
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
        switch(segue.identifier ?? "") {
        case "openPageView":
            
            super.prepare(for: segue, sender: sender)
            
            guard let pageViewController = segue.destination as? TransactionsPageViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedTransactionCell = sender as? PendingTransactionsTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedTransactionCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            pageViewController.page = indexPath.row
            
        default:
            fatalError("Unexpected segue indentifier: \(String(describing: segue.identifier))")
        }
    }
    
    @IBAction func unwindFromPageViewDecline(segue: UIStoryboardSegue) {
        print("decline")
        
        //remove transaction and send response
        self.tableView.reloadData()
    }
    
    @IBAction func unwindFromPageViewSign(segue: UIStoryboardSegue) {
        print("sign")
        //remove transaction and send response
        self.tableView.reloadData()
    }
 
}
