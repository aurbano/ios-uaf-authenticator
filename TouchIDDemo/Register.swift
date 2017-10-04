//
//  Register.swift
//  TouchIDDemo
//
//  Created by Iva on 11/09/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Alamofire
import Registrations

class Register {
    static let sharedInstance = Register()
    private init() {}
    
    func completeRegistration(with scannedData: String, callback: @escaping (Bool) -> ()) {
        let environment = "dev"
        let username = "alex"

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
        
        let requestBuilder = RequestBuilder(url: data.url + Constants.URL.completeReg, method: "PUT")
        
        let header = ["application/json" : "Content-Type"]
        requestBuilder.addHeaders(headers: header)
        
        let requestBody = try! JSONSerialization.data(withJSONObject: jsonResponse, options: [])
        requestBuilder.addBody(body: requestBody)
                
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
                if(regOutcome.status == Status.SUCCESS && regOutcome.attestVerifiedStatus == AttestationStatus.VALID) {
                    print(MessageString.Info.regSuccess)
                    
                    let registration = Registrations.Registration(
                        registrationId: regOutcome.registrationId,
                        appID: (regResponse.header?.appId)!,
                        keyTag: (regResponse.assertions?[0].privKeyTag)!,
                        url: data.url,
                        env: environment,
                        username: username,
                        keyID: (regResponse.assertions?[0].keyID)!
                    )
                    
                    ValidRegistrations.addRegistration(registrationToAdd: registration)
                    ValidRegistrations.saveRegistrations()
                    callback(true)
                }
                else {
                    callback(false)
                }
            }
        }
    }
}
