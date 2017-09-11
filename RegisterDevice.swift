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
    
    var successful = false
    
    private init() { }
    
    func register(username: String, environment: String) {
        
        getRegRequest(username: username, successful: &RegisterDevice.sharedInstance.successful) { (getSuccessful, regRequest) in
            guard (getSuccessful) else {
                print(ErrorString.Requests.getFail)
                return
            }
            
            let fcParams = self.buildFcParams(regRequest: regRequest)
            
            let fcParamsData = fcParams.data(using: .utf8)! as NSData
            let encoded = fcParamsData.base64EncodedString()
            
            let regResponse = RegResponse(header: (regRequest?.header)!, fcparams: encoded)
            regResponse.assertions = [Assertions(fcParams: fcParams, username: username, environment: environment)]
            let jsonResponse = regResponse.toJSONArray()
            
            RegisterDevice.sharedInstance.postRegRequest(json: jsonResponse as! [[String : AnyObject]], successful: &self.successful) { (postSuccessful, regOutcome) in
               guard (postSuccessful) else {
                print(ErrorString.Requests.postFail)
                return
                }
                if (regOutcome.status == Status.SUCCESS) {
                    print(ErrorString.Info.regSuccess)

                    let registration = Registration(appID: (regRequest?.header?.appId)!, keyTag: (regResponse.assertions?[0].privKeyTag)!, url: Constants.domain, env: environment, username: username, keyID: (regResponse.assertions?[0].keyID)!)
                    
                    ValidRegistrations.addRegistration(registrationToAdd: registration)
                    RegisterDevice.sharedInstance.saveRegistrations()
                    
                    self.successful = true
                }
            }
        }
        
//        if (successful) {
//            ValidRegistrations.newRegistration = true
//        }
    }

    private func buildFcParams(regRequest: GetRequest?) -> String {
        let appid = "{\n\"appID\": \"" + (regRequest?.header?.appId)! + "\",\n"
        let facetid = "\"facetID\": \"http://ms.com\",\n"
        let challenge = "\"challenge\": \"" + (regRequest?.challenge)! + "\"\n}"
        return (appid + facetid + challenge)
    }
    
    private func getRegRequest(username: String, successful: inout Bool, taskCallback: @escaping (Bool, GetRequest?) -> ()) {
        let requestBuilder = RequestBuilder(url: Constants.domain + "/v1/public/regRequest/" + username, method: "GET")
        var regRequest: GetRequest?
        
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
                regRequest = GetRequest(json: json[0])!
                taskCallback(true, regRequest)
            }
        }
    }
    
    private func postRegRequest(json: [[String : AnyObject]], successful: inout Bool, taskCallback: @escaping (Bool, RegOutcome) -> ()) {
        let requestBuilder = RequestBuilder(url: Constants.domain + "/v1/public/regResponse", method: "POST")
        
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
                print(responseObject)
                let json = responseObject as! [[String:AnyObject]]
                let regOutcome = RegOutcome(json: json[0])!
                taskCallback(true, regOutcome)
            }
        }
    }
    
    private func saveRegistrations() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ValidRegistrations.registrations, toFile: Registration.ArchiveURL.path)
        if (isSuccessfulSave) {
            print(ErrorString.Info.regSavedSuccess)
        }
        else {
            print(ErrorString.Info.regSavedFail)
        }
    }
}
