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
            let url = reg.url + "/public/getTransactions/" + reg.registrationID
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
                    print(responseObject)
//                    let json = responseObject as! [[String:String]]
//                    if (json.count != 0) {
//                        for obj in json {
//                            let contents = obj["contents"]
//                            let data = contents!.data(using: .utf8)
//                            let transactionData = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves ) as! Dictionary<String, Any>
//                            let transaction = Transaction(json: transactionData!)
//                    PendingTransactions.addTransaction(t: transaction!)
//                        }
//                    }
                }
            }
        }
    }
    
    func initiateTx(data: String, reg: Registration, callback: @escaping (Bool) -> ()) {
        let requestBuilder = RequestBuilder(url: reg.url + "/v1/public/authRequest/" + reg.registrationID, method: "POST")
        requestBuilder.addBody(body: data.data(using: .utf8)!)
        
        Alamofire.request(requestBuilder.getRequest()).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                callback(false)
                
                if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                    print(responseString)
                }
            case .success(let responseObject):
//                let json = responseObject as! [[String:String]]
                print(responseObject)
                callback(true)
            }
        }
    }
}
