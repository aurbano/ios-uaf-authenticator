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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.alertView.center = self.view.center
        showMap(location: coordinates)
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
    
    
    @IBAction func declineButton(_ sender: UIButton) {
        
    }
    
    @IBAction func signButton(_ sender: UIButton) {
        
    }
    

}
