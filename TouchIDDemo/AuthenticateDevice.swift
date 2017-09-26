//
//  AuthenticateDevice.swift
//  TouchIDDemo
//
//  Created by Iva on 17/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Alamofire
import Registrations

class AuthenticateDevice {
    static let sharedInstance = AuthenticateDevice()
    
    private init() { }

    func authenticate(registration: Registrations.Registration, taskCallback: @escaping (Bool, [AuthResult]?) -> ()) {
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
    
    func getPendingTransactions(callback: @escaping (Bool) -> ()) {
        for reg in ValidRegistrations.registrations {
            let url = reg.url + "/v1/public/getTransactions/" + reg.registrationId
            let requestBuilder = RequestBuilder(url: url, method: "GET")
            
            Alamofire.request(requestBuilder.getRequest()).responseJSON { response in
                switch response.result {
                case .failure(let error):
                    print(error)
                    if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                        print(responseString)
                    }
                    callback(false)
                case .success(let responseObject):
                    let json = responseObject as! [[String: Any]]
                    if (json.count != 0) {
                        for obj in json {
                            let contents = obj["content"] as! String
                            let txId = obj["id"] as! Int64
//                            let data = contents.data(using: .utf8)
//                            let transactionData = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves ) as! Dictionary<String, Any>
                            let transaction = Transaction(data: contents, registrationId: reg.registrationId, txId: txId)
                            PendingTransactions.addTransaction(t: transaction)
                            callback(true)
                        }
                    }
                    callback(false)
                }
            }
        }
    }
    
    func initiateTx(data: String, reg: Registrations.Registration, callback: @escaping (Bool) -> ()) {
        let requestBuilder = RequestBuilder(url: reg.url + "/v1/public/authRequest/" + reg.registrationId, method: "POST")
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
    
    func respondTx(response: String, index: Int64, registration: Registrations.Registration, callback: @escaping (Bool) -> ()) {
        
        let keys = KeysManipulation()
        let pair = keys.getKeyPair(tag: registration.keyTag)
        let algorithm: SecKeyAlgorithm = .ecdsaSignatureMessageX962SHA256
        let signature = keys.signData(dataForSigning: Array<UInt8>(response.data(using: .utf8)!), key: pair.privateKey!, algorithm: algorithm)

        let url = registration.url + "/v1/public/authResponse/" + registration.registrationId + "/" + String(describing: index)
        let requestBuilder = RequestBuilder(url: url, method: "PUT")
        
        let respBytes = Array<UInt8>(response.utf8)
        let encodedResp = respBytes.toBase64()
        let encodedSignature = signature.toBase64()

        let body: [[String: Any]] = [["response": encodedResp as Any,
                                      "signature": encodedSignature!]]
        requestBuilder.addBody(body: body)
        
        Alamofire.request(requestBuilder.getRequest()).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                callback(false)
                
                if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                    print(responseString)
                }
            case .success(let responseObject):
                print(responseObject)
                callback(true)
            }
        }
    }
}
