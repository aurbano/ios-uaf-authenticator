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
    
    func getPendingTransactions(callback: @escaping (Bool) -> ()) {
        for reg in ValidRegistrations.registrations {
            let url = reg.url + "/v1/public/authRequest/" + reg.registrationId
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
                    print(responseObject)
                    let json = responseObject as! [[String: Any]]
                    var txRequests = [TransactionRequest]()
                    if (json.count != 0) {
                        for obj in json {
                            let request = TransactionRequest(json: obj)!
                            txRequests.append(request)
                            if (!(request.transaction?.isEmpty)!) {
                                let tx = request.transaction![0]
                                
                                let transaction = Transaction(data: tx.content!, registrationId: reg.registrationId, challenge: request.challenge!)
                                PendingTransactions.addTransaction(t: transaction)
                            }
                        }
                        callback(true)
                    }
                    callback(false)
                }
            }
        }
    }
    
    func respondTx(response: String, challenge: String, registration: Registrations.Registration, callback: @escaping (Bool) -> ()) {
        
        let challengeBytes = Array<UInt8>(challenge.data(using: .utf8)!)
        let keys = KeysManipulation()
        let pair = keys.getKeyPair(tag: registration.keyTag)
        let algorithm: SecKeyAlgorithm = .ecdsaSignatureMessageX962SHA256
        let signature = keys.signData(dataForSigning: challengeBytes, key: pair.privateKey!, algorithm: algorithm)

        let url = registration.url + Constants.URL.transactions + registration.registrationId + "/" + challenge
        
        let requestBuilder = RequestBuilder(url: url, method: "PUT")
        let encodedSignature = signature.toBase64()
        
        let body: [[String: Any]] = [["response": response as Any,
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
