//
//  AuthenticateDevice.swift
//  TouchIDDemo
//
//  Created by Iva on 17/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Alamofire

class AuthenticateDevice {
    static let sharedInstance = AuthenticateDevice()
    
    private init() { }

    func authenticate(registration: Registration, taskCallback: @escaping (Bool, [AuthResult]?) -> ()) {
        let reqRequestBuilder = RequestBuilder(url: Constants.domain + "/v1/public/authRequest/" + Constants.appID, method: "POST")
        var authRequest: GetRequest?
        
        Alamofire.request(reqRequestBuilder.getRequest()).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                taskCallback(false, nil)
                
                if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                    print(responseString)
                }
            case .success(let responseObject):
                let json = responseObject as! [[String:AnyObject]]
                authRequest = GetRequest(json: json[0])!
                
                let fcParams = Utils.buildFcParams(request: authRequest)

                let fcParamsData = fcParams.data(using: .utf8)! as NSData
                let encoded = fcParamsData.base64EncodedString()
                
                let authResponse = AuthResponse(header: (authRequest?.header)!, fcparams: encoded)
                authResponse.assertions = [Assertions(fcParams: fcParams, keyTag: registration.keyTag, keyID: registration.keyID)]
                let jsonResponse = authResponse.toJSONArray()
        
                let respRequestBuilder = RequestBuilder(url: registration.url + "/v1/public/authResponse", method: "POST")
        
                let header = ["application/json" : "Content-Type"]
                respRequestBuilder.addHeaders(headers: header)
                
                let data = try! JSONSerialization.data(withJSONObject: jsonResponse as! [[String : AnyObject]], options: [])
                respRequestBuilder.addBody(body: data)
                
                Alamofire.request(respRequestBuilder.getRequest()).responseJSON { response in
                    switch response.result {
                    case .failure(let error):
                        print(error)
                        
                        if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                            print(responseString)
                        }
                    case .success(let responseObject):
                        print(responseObject)
                        let json = responseObject as! [[String:AnyObject]]
                        var authResult = [AuthResult()]
                        for obj in json {
                            authResult.append(AuthResult(json: obj)!)
                        }
                        taskCallback(true, authResult)
                    }
                }
            }
        }
    }
    
    func getPendingTransactions() {
        for reg in ValidRegistrations.registrations {
            let url = reg.url + "public/getTransactions/" + reg.registrationID
            let requestBuilder = RequestBuilder(url: url, method: "GET")
            
            Alamofire.request(requestBuilder.getRequest()).responseJSON { response in
                switch response.result {
                case .failure(let error):
                    print(error)
//                    taskCallback(false, nil)
                    
                    if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                        print(responseString)
                    }
                case .success(let responseObject):
                    let json = responseObject as! [[String:AnyObject]]
                    //TODO Check if json is empty, if not - create new transaction from the data
                    let transaction = Transaction(value: 0, currency: Currency.gbp, date: "29/09/2017", company: "aa", location: [Double]())
                    PendingTransactions.addTransaction(t: transaction)
                }
            }
        }
    }
    
//    private func authRequest(registrationID: String, taskCallback: @escaping (Bool, GetRequest?)  -> ()) {
//        let requestBuilder = RequestBuilder(url: Constants.domain + "/v1/public/authRequest/" + Constants.appID, method: "POST")
//        var authRequest: GetRequest?
//        
//        Alamofire.request(requestBuilder.getRequest()).responseJSON { response in
//            switch response.result {
//            case .failure(let error):
//                print(error)
//                taskCallback(false, nil)
//                
//                if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
//                    print(responseString)
//                }
//            case .success(let responseObject):
//                let json = responseObject as! [[String:AnyObject]]
//                authRequest = GetRequest(json: json[0])!
//                taskCallback(true, authRequest)
//            }
//        }
//    }
    
//    private func authResponse(json: [[String : AnyObject]], taskCallback: @escaping (Bool, [AuthResult]?) -> ()) {
//        let requestBuilder = RequestBuilder(url: Constants.domain + "/v1/public/authResponse", method: "POST")
//        
//        let header = ["application/json" : "Content-Type"]
//        requestBuilder.addHeaders(headers: header)
//        
//        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
//        requestBuilder.addBody(body: data)
//        
//        Alamofire.request(requestBuilder.getRequest()).responseJSON { response in
//            switch response.result {
//            case .failure(let error):
//                print(error)
//                
//                if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
//                    print(responseString)
//                }
//            case .success(let responseObject):
//                print(responseObject)
//                let json = responseObject as! [[String:AnyObject]]
//                var authResult = [AuthResult()]
//                for obj in json {
//                    authResult.append(AuthResult(json: obj)!)
//                }
//                taskCallback(true, authResult)
//            }
//        }
//    }
}
