//
//  old.swift
//  TouchIDDemo
//
//  Created by Iva on 14/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation

//let tag = "com.ms.touchid.keys.testkey".data(using: .ascii)!
//

// MARK: Actions
//    @IBAction func createPairAny(_ sender: UIButton) {
//        let anyPair = try? self.generateKeyPairAny()
//        if (anyPair?.privateKey != nil) {
//            self.addText(field: infoTextLabel, text: "Private key any generated")
//        }
//    }


//    @IBAction func createPairCurrent(_ sender: UIButton) {
//        let currentPair = try? generateKeyPairCurrentSet()
//        if (currentPair?.privateKey != nil) {
//            self.addText(field: infoTextLabel, text: "Private key any generated")
//        }
//    }

//    @IBAction func retrievePrivateAny(_ sender: UIButton) {
//        let uuid = UUID().uuidString.data(using: .ascii)
//        let privateKey = retrievePrivateKey(tag: self.anytag)
//        if (privateKey != nil) {
//            self.addText(field: self.infoTextLabel, text: "Private key any retrieved")
//            guard signChallenge(key: privateKey!, message: uuid! as CFData, algorithm: .ecdsaSignatureDigestX962SHA256) != nil
//            else {
//                addText(field: infoTextLabel, text: "Signature not created")
//                return
//            }
//            addText(field: infoTextLabel, text: "Signed any finger")
//        }
//    }

//    @IBAction func retrievePrivateCurrent(_ sender: UIButton) {
//        let uuid = UUID().uuidString.data(using: .ascii)
//        let privateKey = retrievePrivateKey(tag: self.currenttag)
//        if (privateKey != nil) {
//            self.addText(field: self.infoTextLabel, text: "Private key current set retrieved")
//            guard signChallenge(key: privateKey!, message: uuid! as CFData, algorithm: .ecdsaSignatureDigestX962SHA256) != nil
//            else {
//                addText(field: infoTextLabel, text: "Signature not created")
//                return
//            }
//            addText(field: infoTextLabel, text: "Signed current set")
//        }
//    }

//    func authenticateUsingTouchID(uuid: Data) {
//
//        //Create authentication context
//        let authenticationContext = LAContext()
//
//        //Reason for biometrics authentication
//        let reasonString = "Use TouchID to authorise signing"
//
//        var authError: NSError? = nil
//
//        guard #available(iOS 8.0, OSX 10.12, *) else {
//            addText(field: self.infoTextLabel, text: "Too old operating system, please update ❌")
//            return
//        }
//
//        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else {
//            addText(field: self.infoTextLabel, text: "This device does not support TouchID")
//            return
//        }
//
//        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: {(success, error) -> Void in
//            if (success) {
//                self.addText(field: self.infoTextLabel, text: "Signing authorised ✔")
//                let privateKey = self.retrievePrivateKey(tag: self.tag)
//                guard let publicKey = SecKeyCopyPublicKey(privateKey!) else {
//                    self.addText(field: self.infoTextLabel, text: "Public key could not be retrieved ✔")
//                    return
//                }
//                self.addText(field: self.infoTextLabel, text: "Public key retrieved ✔")
//
//                // Sign number with private key
//                let algorithm: SecKeyAlgorithm = .ecdsaSignatureDigestX962SHA256
//                let signature = self.signChallenge(key: privateKey!, message: uuid as CFData, algorithm: algorithm)
//                self.addText(field: self.infoTextLabel, text: "Challenge signed ✔")
//
//                // Verify signature
//                self.verifySignature(key: publicKey, signature: signature!, algorithm: algorithm, data: uuid as CFData)
//                self.addText(field: self.infoTextLabel, text: "Signature verified ✔")
//
//            }
//            else {
//                if error != nil {
//                    self.addText(field: self.infoTextLabel, text: "Sorry, I do not recognize you ❌")
//                }
//            }
//        })
//    }

//    func generateKeyPairAny() throws -> (privateKey: SecKey?, publicKey: SecKey?) {
//
//        guard
//            let access = SecAccessControlCreateWithFlags(
//                kCFAllocatorDefault,
//                kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
//                [.privateKeyUsage,.touchIDAny],
//                nil
//            ) else {
//                addText(field: infoTextLabel, text: "could not create private key any error")
//                return (nil, nil)
//        }
//
//
//        // private key parameters
//        let privateKeyParams: [String: Any] = [
//            kSecAttrAccessControl as String:    access,
//            kSecAttrIsPermanent as String:      true,
//            kSecAttrApplicationTag as String:   self.anytag
//        ]
//
//
//        // global parameters for our key generation
//        let parameters: [String: Any] = [
//            kSecAttrTokenID as String:          kSecAttrTokenIDSecureEnclave,
//            kSecAttrKeyType as String:          kSecAttrKeyTypeEC,
//            kSecAttrKeySizeInBits as String:    256,
//            kSecPrivateKeyAttrs as String:      privateKeyParams
//        ]
//
//
//        guard
//            let privateKey = SecKeyCreateRandomKey(parameters as CFDictionary, nil) else {
//                print("ECC KeyGen Error!")
//                return (nil, nil)
//        }
//        guard
//            let publicKey = SecKeyCopyPublicKey(privateKey) else {
//                print("ECC Pub KeyGen Error")
//                return (nil, nil)
//        }
//        return (privateKey, publicKey)
//    }

//    func generateKeyPairCurrentSet() throws -> (privateKey: SecKey?, publicKey: SecKey?) {
//        guard let access = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
//                                                           kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
//                                                           [.privateKeyUsage, .touchIDCurrentSet],
//                                                           nil)
//        else {
//            addText(field: infoTextLabel, text: "Could not create private key current set")
//            return (nil, nil)
//        }
//
//        let privateKeyParams: [String: Any] = [ kSecAttrIsPermanent     as String:  true,
//                                              kSecAttrApplicationTag  as String:  self.currenttag,
//                                              kSecAttrAccessControl   as String:  access ]
//
//        let attributes: [String: Any] = [
//            kSecAttrKeyType         as String:    kSecAttrKeyTypeEC,
//            kSecAttrKeySizeInBits   as String:    256,
//            kSecAttrTokenID         as String:    kSecAttrTokenIDSecureEnclave,
//            kSecPrivateKeyAttrs     as String:    privateKeyParams ]
//        var keyCreationError: Unmanaged<CFError>?
//        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &keyCreationError)
//            else {
//                addText(field: infoTextLabel, text: "Error generating the key pair")
//                throw keyCreationError!.takeRetainedValue() as Error
//        }
//
//        let publicKey = SecKeyCopyPublicKey(privateKey)
//        return (privateKey, publicKey)
//    }

//    func retrievePrivateKey(tag: Data) -> SecKey? {
//        let getquery: [String: Any] = [ kSecClass              as String:  kSecClassKey,
//                                        kSecAttrApplicationTag as String:  tag,
//                                        kSecAttrKeyType        as String:  kSecAttrKeyTypeEC,
//                                        kSecReturnRef          as String:  true ]
//        var item: CFTypeRef?
//        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
//        guard status == errSecSuccess else {
//            self.addText(field: self.infoTextLabel, text: "Could not retrieve private key")
//            return nil
//        }
//        let privateKey = item as! SecKey
//        return privateKey
//    }

//    func signChallenge(key: SecKey, message: CFData, algorithm: SecKeyAlgorithm) -> CFData? {
//        guard SecKeyIsAlgorithmSupported(key, .sign, algorithm) else {
//            self.authenticateLabel.text = (self.authenticateLabel.text ?? "") + "Algorithm not supported by signing key ❌"
//            return nil
//        }
//
//        var signingError: Unmanaged<CFError>?
//        guard let signature = SecKeyCreateSignature(key, algorithm, message, &signingError) else {
//            self.authenticateLabel.text = (self.authenticateLabel.text ?? "") + "Challenge could not be signed ❌"
//            return nil
//        }
//        return signature
//    }
//
//    func verifySignature(key: SecKey, signature: CFData, algorithm: SecKeyAlgorithm, data: CFData) {
//        guard SecKeyIsAlgorithmSupported(key, .verify, algorithm) else {
//            self.authenticateLabel.text = (self.authenticateLabel.text ?? "") + "Algorithm not supported by verifying key ❌"
//            return
//        }
//        var error: Unmanaged<CFError>?
//        guard SecKeyVerifySignature(key, algorithm, data, signature, &error) else {
//            self.authenticateLabel.text = (self.authenticateLabel.text ?? "") + "Signature corrupted ❌"
//            return
//        }
//    }
//

//    func getPublicKey(tag: String) -> Array<UInt8>? {
//        let pair = try? generateKeyPair(t)()
//        var pubKeyArray = Array<UInt8>()
//        var error:Unmanaged<CFError>?
//        if let cfdata = SecKeyCopyExternalRepresentation((pair?.publicKey!)!, &error) {
//            let data:Data = cfdata as Data
//            pubKeyArray = Array<UInt8>(data)
//        }
//
//        return pubKeyArray
//    }


//    @IBAction func register(_ sender: UIButton) {
//        self.view.endEditing(true)
//        var overlay = UIView()
//        let activityIndicator = UIActivityIndicatorView()
//
//        if (username.text != "" && environment.text != "") {
//            overlay = UIView(frame: self.view.frame)
//            overlay.backgroundColor = UIColor.black
//            overlay.alpha = 0.8
//
//            activityIndicator.center = self.view.center
//            activityIndicator.hidesWhenStopped = true
//
//            self.view.addSubview(overlay)
//            overlay.addSubview(activityIndicator)
//
//            activityIndicator.startAnimating()
//
//            let trimmedUsername = username.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            let trimmedEnv = environment.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//
//            Register.sharedInstance.register(username: trimmedUsername, environment: trimmedEnv) { (success) in
//                self.username.text = ""
//                self.environment.text = ""
//
//
//                if (success) {
//                    activityIndicator.stopAnimating()
//                    overlay.removeFromSuperview()
//
//                    let alert = UIAlertController(title: MessageString.Info.regSuccess, message: "", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in NSLog("Registration complete alert")}))
//
//                    self.present(alert, animated: true, completion: nil)
//                }
//                else {
//                    let alert = UIAlertController(title: MessageString.Info.regFail, message: "", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in NSLog("Registration fail alert")}))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//        }
//    }

//func register(username: String, environment: String, callback: @escaping (Bool) -> ()) {
//    
//    let requestBuilder = RequestBuilder(url: Constants.domain + "/v1/public/regRequest/" + username, method: "GET")
//    //        var regRequest: GetRequest?
//    
//    var getResult: GetRequest?
//    Alamofire.request(requestBuilder.getRequest()).responseJSON { response in
//        switch response.result {
//        case .failure(let error):
//            print(error)
//            getResult = nil
//            callback(false)
//            
//            if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
//                print(responseString)
//            }
//        case .success(let responseObject):
//            let json = responseObject as! [[String:AnyObject]]
//            getResult = GetRequest(json: json[0])!
//            let fcParams = Utils.buildFcParams(request: getResult)
//            
//            let fcParamsData = fcParams.data(using: .utf8)! as NSData
//            let encoded = fcParamsData.base64EncodedString()
//            
//            let regResponse = RegResponse(header: (getResult?.header)!, fcparams: encoded)
//            regResponse.assertions = [Assertions(fcParams: fcParams, username: username, environment: environment)]
//            let jsonResponse = regResponse.toJSONArray()
//            
//            let requestBuilder = RequestBuilder(url: Constants.domain + "/v1/public/regResponse", method: "POST")
//            
//            let header = ["application/json" : "Content-Type"]
//            requestBuilder.addHeaders(headers: header)
//            
//            let data = try! JSONSerialization.data(withJSONObject: jsonResponse, options: [])
//            requestBuilder.addBody(body: data)
//            
//            var postResult: RegOutcome?
//            Alamofire.request(requestBuilder.getRequest()).responseJSON { response in
//                switch response.result {
//                case .failure(let error):
//                    print(error)
//                    
//                    if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
//                        print(responseString)
//                        callback(false)
//                    }
//                case .success(let responseObject):
//                    print(responseObject)
//                    let json = responseObject as! [[String:AnyObject]]
//                    let regOutcome = RegOutcome(json: json[0])!
//                    postResult = regOutcome
//                    if(postResult?.status == Status.SUCCESS && postResult?.attestVerifiedStatus == AttestationStatus.VALID) {
//                        print(MessageString.Info.regSuccess)
//                        
//                        let registration = Registration(appID: (getResult?.header?.appId)!, keyTag: (regResponse.assertions?[0].privKeyTag)!, url: Constants.domain, env: environment, username: username, keyID: (regResponse.assertions?[0].keyID)!)
//                        
//                        ValidRegistrations.addRegistration(registrationToAdd: registration)
//                        Register.sharedInstance.saveRegistrations()
//                        callback(true)
//                    }
//                }
//            }
//        }
//    }
//}


//func showAlert(latitude: Double, longitude: Double) {
//    
//    
//    let mapView = MKMapView()
//    let alert = UIAlertController(title: "Location", message: "User registering from this location", preferredStyle: .alert)
//    
//    
//    mapView.mapType = .standard
//    mapView.showsBuildings = true
//    
//    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    
//    let span = MKCoordinateSpanMake(0.005, 0.005)
//    let region = MKCoordinateRegion(center: location, span: span)
//    mapView.setRegion(region, animated: true)
//    
//    let annotation = MKPointAnnotation()
//    annotation.coordinate = location
//    mapView.addAnnotation(annotation)
//    
//    alert.view.addSubview(mapView)
//    
//    alert.addAction(UIAlertAction(title: NSLocalizedString("Allow", comment: "Default action"), style: UIAlertActionStyle.cancel, handler: {_ in NSLog("Registration fail alert")}))
//    
//    alert.addAction(UIAlertAction(title: NSLocalizedString("Decline", comment: "Default action"), style:UIAlertActionStyle.destructive , handler: {_ in NSLog("Registration fail alert")}))
//    
//    self.present(alert, animated: true, completion: nil)
//    
//}

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


//{
//    "company": String,
//    "value": Int,
//    "currency": String,
//    "location": [Double, Double],
//    "timestamp": Long
//}
