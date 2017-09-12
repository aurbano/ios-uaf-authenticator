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

    func authenticate(registration: Registration) {
        getAuthRequest(username: registration.username) { (getSuccessful, authRequest)  in
            guard (getSuccessful) else {
                print(MessageString.Requests.getFail)
                return
            }
            
            let fcParams = Utils.buildFcParams(request: authRequest)

            let fcParamsData = fcParams.data(using: .utf8)! as NSData
            let encoded = fcParamsData.base64EncodedString()

            let authResponse = RegResponse(header: (authRequest?.header)!, fcparams: encoded)
            authResponse.assertions = [Assertions(fcParams: fcParams, keyTag: registration.keyTag, keyID: registration.keyID)]
            let jsonResponse = authResponse.toJSONArray()

            self.postAuthRequest(json: jsonResponse as! [[String : AnyObject]]) { (postSuccessful, regOutcome) in
                guard (postSuccessful) else {
                    print(MessageString.Requests.postFail)
                    return
                }
                if (regOutcome?.status == Status.SUCCESS) {
                    print(MessageString.Info.authSuccess)
                }
            }
        }
    }
    
    func getAuthRequest(username: String, taskCallback: @escaping (Bool, GetRequest?)  -> ()) {
        let requestBuilder = RequestBuilder(url: Constants.domain + "/v1/public/authRequest/" + Constants.appID, method: "GET")
        var authRequest: GetRequest?
        
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
                authRequest = GetRequest(json: json[0])!
                taskCallback(true, authRequest)
            }
        }
    }
    
    private func postAuthRequest(json: [[String : AnyObject]], taskCallback: @escaping (Bool, RegOutcome?) -> ()) {
        let requestBuilder = RequestBuilder(url: Constants.domain + "/v1/public/authResponse", method: "POST")
        
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
}
