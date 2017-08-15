//
//  RegisterDevice.swift
//  TouchIDDemo
//
//  Created by Iva on 15/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Alamofire

class RegisterDevice {
    static let sharedInstance = RegisterDevice()
    private let domain = "http://localhost:8080"
    
    func register() {
        getRegRequest(domain: self.domain) { (getSuccessful, regRequest) in
            guard (getSuccessful) else {
                print("Get request unsuccessful")
                return
            }
            
            let appid = "{\n\"appID\": \"" + (regRequest?.header?.appId)! + "\",\n"
            let facetid = "\"facetID\": \"http://ms.com\",\n"
            let challenge = "\"challenge\": \"" + (regRequest?.challenge)! + "\"\n}"
            
            let fcParams = (appid + facetid + challenge)
            let fcParamsData = fcParams.data(using: .utf8)! as NSData
            let encoded = fcParamsData.base64EncodedString()
            
            let regResponse = RegResponse(header: (regRequest?.header)!, fcparams: encoded)
            regResponse.assertions = [Assertions(fcParams: fcParams)]
            let jsonResponse = regResponse.toJSONArray()
            
            self.postRegRequest(domain: self.domain, json: jsonResponse as! [[String : AnyObject]]) { (postSuccessful, regOutcome) in
                guard (postSuccessful) else {
                    print("Post request unsuccessful")
                    return
                }
                if (regOutcome.status == Status.SUCCESS) {
                    print("Registration successful")
                    
                    self.saveRegistration(appID: (regRequest?.header?.appId)!, keyTag: (regResponse.assertions?[0].assertion!)!, url: self.domain)
                }
            }
        }
    }
    
    func getRegRequest(domain: String, taskCallback: @escaping (Bool, RegRequest?) -> ()) {
        let requestBuilder = RequestBuilder(url: domain + "/v1/public/regRequest", method: "GET")
        var regRequest: RegRequest?
        
        Alamofire.request(requestBuilder.getRequest()).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                taskCallback(false, nil)
                
                if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                    print(responseString)
                }
            case .success(let responseObject):
                let json = responseObject as! [[String:AnyObject]]
                regRequest = RegRequest(json: json[0])!
                taskCallback(true, regRequest)
            }
        }
    }
    
    func postRegRequest(domain: String, json: [[String : AnyObject]], taskCallback: @escaping (Bool, RegOutcome) -> ()) {
        let requestBuilder = RequestBuilder(url: domain + "/v1/public/regResponse", method: "POST")
        
        let header = ["application/json" : "Content-Type"]
        requestBuilder.addHeaders(headers: header)
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        requestBuilder.addBody(body: data)
        
        Alamofire.request(requestBuilder.getRequest()).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                
                if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                    print(responseString)
                }
            case .success(let responseObject):
                let json = responseObject as! [[String:AnyObject]]
                let regOutcome = RegOutcome(json: json[0])!
                taskCallback(true, regOutcome)
            }
        }
    }
    
    private func saveRegistration(appID: String, keyTag: String, url: String) {
        let registration = Registration(appID: appID, keyTag: keyTag, url: url, env: "uat")
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(registration, toFile: Registration.ArchiveURL.path)
        if (isSuccessfulSave) {
            print("Registration data saved successfully")
        }
        else {
            print("failed to save registration data")
        }
    }
    
}
