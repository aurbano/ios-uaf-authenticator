//
//  Register.swift
//  TouchIDDemo
//
//  Created by Iva on 11/09/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Alamofire

class Register {
    static let sharedInstance = Register()
    private init() {}
    
    func register(username: String, environment: String, callback: @escaping (Bool) -> ()) {
        
        let requestBuilder = RequestBuilder(url: Constants.domain + "/v1/public/regRequest/" + username, method: "GET")
        var regRequest: GetRequest?
        
        var getResult: GetRequest?
        Alamofire.request(requestBuilder.getRequest()).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                getResult = nil
                callback(false)
                
                if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                    print(responseString)
                }
            case .success(let responseObject):
                let json = responseObject as! [[String:AnyObject]]
                getResult = GetRequest(json: json[0])!
                getResult = regRequest
                let fcParams = Utils.buildFcParams(request: getResult)
                
                let fcParamsData = fcParams.data(using: .utf8)! as NSData
                let encoded = fcParamsData.base64EncodedString()
                
                let regResponse = RegResponse(header: (getResult?.header)!, fcparams: encoded)
                regResponse.assertions = [Assertions(fcParams: fcParams, username: username, environment: environment)]
                let jsonResponse = regResponse.toJSONArray()
                
                let requestBuilder = RequestBuilder(url: Constants.domain + "/v1/public/regResponse", method: "POST")
                
                let header = ["application/json" : "Content-Type"]
                requestBuilder.addHeaders(headers: header)
                
                let data = try! JSONSerialization.data(withJSONObject: jsonResponse, options: [])
                requestBuilder.addBody(body: data)
                
                var postResult: RegOutcome?
                Alamofire.request(requestBuilder.getRequest()).responseJSON { response in
                    switch response.result {
                    case .failure(let error):
                        print(error)
                        
                        if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                            print(responseString)
                            callback(false)
                        }
                    case .success(let responseObject):
                        print(responseObject)
                        let json = responseObject as! [[String:AnyObject]]
                        let regOutcome = RegOutcome(json: json[0])!
                        postResult = regOutcome
                        if(postResult?.status == Status.SUCCESS && postResult?.attestVerifiedStatus == AttestationStatus.VALID) {
                            print(MessageString.Info.regSuccess)
                            
                            let registration = Registration(appID: (getResult?.header?.appId)!, keyTag: (regResponse.assertions?[0].privKeyTag)!, url: Constants.domain, env: environment, username: username, keyID: (regResponse.assertions?[0].keyID)!)
                            
                            ValidRegistrations.addRegistration(registrationToAdd: registration)
                            Register.sharedInstance.saveRegistrations()
                            callback(true)
                        }
                    }
                }
            }
        }
    }
    
    func completeRegistration(with scannedData: String, callback: @escaping (Bool) -> ()) {
        let environment = "dev"
        let username = "iva"

        guard let data = Utils.parseScannedData(data: scannedData) else {
            print("QR not formatted properly")
            return
        }
        
        let fcParams = Utils.buildFcParams(challenge: data.challenge)
        
        let fcParamsData = fcParams.data(using: .utf8)! as NSData
        let encoded = fcParamsData.base64EncodedString()
        
        let regResponse = RegResponse(header: Header(serverData: data.serverData), fcparams: encoded)
        regResponse.assertions = [Assertions(fcParams: fcParams, username: username, environment: environment)]
        let jsonResponse = regResponse.toJSONArray()
        
        let requestBuilder = RequestBuilder(url: data.url, method: "POST")
        
        let header = ["application/json" : "Content-Type"]
        requestBuilder.addHeaders(headers: header)
        
        let requestBody = try! JSONSerialization.data(withJSONObject: jsonResponse, options: [])
        requestBuilder.addBody(body: requestBody)
        
        var postResult: RegOutcome?
        Alamofire.request(requestBuilder.getRequest()).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                
                if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                    print(responseString)
                    callback(false)
                }
            case .success(let responseObject):
                print(responseObject)
                let json = responseObject as! [[String:AnyObject]]
                let regOutcome = RegOutcome(json: json[0])!
                postResult = regOutcome
                if(postResult?.status == Status.SUCCESS && postResult?.attestVerifiedStatus == AttestationStatus.VALID) {
                    print(MessageString.Info.regSuccess)
                    
                    let registration = Registration(appID: (regResponse.header?.appId)!, keyTag: (regResponse.assertions?[0].privKeyTag)!, url: Constants.domain, env: environment, username: username, keyID: (regResponse.assertions?[0].keyID)!)
                    
                    ValidRegistrations.addRegistration(registrationToAdd: registration)
                    Register.sharedInstance.saveRegistrations()
                    callback(true)
                }
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
