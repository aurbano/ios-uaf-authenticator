//
//  AlertViewController.swift
//  TouchIDDemo
//
//  Created by Iva on 12/09/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AlertViewController: ViewController {

    var pageIndex: Int = 0
    var coordinates: CLLocationCoordinate2D!
    var company: String!
    var date: String!
    var value: String!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.alertView.center = self.view.center
        showMap(location: coordinates)
        companyLabel.text = MessageString.Labels.company + company
        valueLabel.text = MessageString.Labels.value + value
        dateLabel.text = MessageString.Labels.date + date
        
//        let url = URL(string: "https://www.morganstanley.com/")
//        let reqObj = URLRequest(url: url!)
//        webView.loadRequest(reqObj)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMap(location: CLLocationCoordinate2D) {

        mapView.mapType = .standard
        mapView.showsBuildings = true
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func declineButtonClick(_ sender: UIButton) {
        let index = self.pageIndex
        let tx = PendingTransactions.getTransaction(atIndex: index)
        guard let reg = ValidRegistrations.getRegistrationFrom(registrationId: tx.registrationId!) else {
            return
        }

        AuthenticateDevice.sharedInstance.respondTx(response: MessageString.Server.declinedTx, index: tx.txId!, registration: reg) { success in
            PendingTransactions.removeTransaction(atIndex: index)
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("UPDATED_DATA"), object: nil)
        }
    }
    
    @IBAction func signButtonClick(_ sender: UIButton) {
        let index = self.pageIndex
        let tx = PendingTransactions.getTransaction(atIndex: index)
        guard let reg = ValidRegistrations.getRegistrationFrom(registrationId: tx.registrationId!) else {
            return
        }
        
        AuthenticateDevice.sharedInstance.respondTx(response: MessageString.Server.signedTx, index: tx.txId!, registration: reg) { success in
            PendingTransactions.removeTransaction(atIndex: index)
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("UPDATED_DATA"), object: nil)
        }
    }
}
