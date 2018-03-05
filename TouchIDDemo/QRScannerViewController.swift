//
//  QRScannerViewController.swift
//  TouchIDDemo
//
//  Created by Iva on 07/09/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import CoreLocation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var captureSession: AVCaptureSession!
    var qrCodeFrameView: UIView!
    var dataCaptured: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 44.0/255.0, green: 152.0/255.0, blue: 128.0/255.0, alpha: 1)
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 15.0/255.0, green: 142.0/255.0, blue: 199.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        self.tabBarController?.tabBar.isHidden = true

        self.navigationController?.navigationBar.tintColor = UIColor.white
        captureSession = AVCaptureSession()
        let videoCaptureDevice = AVCaptureDevice.default(for: .video)
        
        do {
            let input = try AVCaptureDeviceInput(device: videoCaptureDevice!)
            captureSession.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = view.layer.bounds
            
            view.layer.addSublayer(videoPreviewLayer)
            
            captureSession.startRunning()
            
            // QR code frame to highlight the QR code
            qrCodeFrameView = UIView()
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        }
        catch {
            print(error)
            return
        }

    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView.frame = CGRect.zero
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObj = videoPreviewLayer.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView.frame = barCodeObj!.bounds
            
            if metadataObj.stringValue != nil {
                dataCaptured = metadataObj.stringValue!
                self.performSegue(withIdentifier: "unwindToRegistrationsTableView", sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
