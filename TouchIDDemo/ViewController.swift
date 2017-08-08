//
//  ViewController.swift
//  TouchIDDemo
//
//  Created by Iva on 24/07/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import UIKit
import LocalAuthentication
import Foundation
import Alamofire

class ViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var authenticateLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    var step = 1
    let tag = "com.ms.touchid.keys.testkey".data(using: .ascii)!
    let anytag = "com.ms.touchid.keys.keyany".data(using: .utf8)!
    let currenttag = "com.ms.touchid.keys.keycurrent".data(using: .utf8)!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func createPairAny(_ sender: UIButton) {
        let anyPair = try? self.generateKeyPairAny()
        if (anyPair?.privateKey != nil) {
            self.addText(field: infoTextLabel, text: "Private key any generated")
        }
    }
    
    
    @IBAction func createPairCurrent(_ sender: UIButton) {
        let currentPair = try? generateKeyPairCurrentSet()
        if (currentPair?.privateKey != nil) {
            self.addText(field: infoTextLabel, text: "Private key any generated")
        }
//        if (currentPair?.privateKey != nil) {
//            self.addText(field: infoTextLabel, text: "Private key current set generated")
//        }

//        step = 1
        
//        // Create public - private key pair
//        let keyPair = try? self.generateKeyPair()
//        if keyPair?.publicKey != nil {
//            self.authenticateLabel.text = (self.authenticateLabel.text ?? "") + "\nKey created successfully"
//        }
        
        // Generate random number to use as a challenge
//        let uuid = UUID().uuidString.data(using: .ascii)
//        addText(field: self.infoTextLabel, text: "Challenge created ✔")
//
//        //Get the public key
//        authenticateUsingTouchID(uuid: uuid!)
////        addText(field: self.infoTextView, text:"Private key reference retrieved")
    }
    
    @IBAction func retrievePrivateAny(_ sender: UIButton) {
        let uuid = UUID().uuidString.data(using: .ascii)
        let privateKey = retrievePrivateKey(tag: self.anytag)
        if (privateKey != nil) {
            self.addText(field: self.infoTextLabel, text: "Private key any retrieved")
            guard signChallenge(key: privateKey!, message: uuid! as CFData, algorithm: .ecdsaSignatureDigestX962SHA256) != nil
            else {
                addText(field: infoTextLabel, text: "Signature not created")
                return
            }
            addText(field: infoTextLabel, text: "Signed any finger")
        }
    }
    
    @IBAction func retrievePrivateCurrent(_ sender: UIButton) {
        let uuid = UUID().uuidString.data(using: .ascii)
        let privateKey = retrievePrivateKey(tag: self.currenttag)
        if (privateKey != nil) {
            self.addText(field: self.infoTextLabel, text: "Private key current set retrieved")
            guard signChallenge(key: privateKey!, message: uuid! as CFData, algorithm: .ecdsaSignatureDigestX962SHA256) != nil
            else {
                addText(field: infoTextLabel, text: "Signature not created")
                return
            }
            addText(field: infoTextLabel, text: "Signed current set")
        }
    }
    
    @IBAction func register(_ sender: UIButton) {        
        getRegRequest() { (getSuccessful, regRequest) in
            guard (getSuccessful) else {
                self.addText(field: self.infoTextLabel, text: "Get request unsuccessful")
                return
            }
            
            let appid = "{\n\"appID\": \"" + (regRequest?.header?.appId)! + "\",\n"
            let facetid = "\"facetID\": \"http://ms.com\",\n"
            let challenge = "\"challenge\": \"" + (regRequest?.challenge)! + "\"\n}"
            
            let fcparams = (appid + facetid + challenge).data(using: .utf8)! as NSData
            let encoded = fcparams.base64EncodedString()

            let regResponse = RegResponse(header: (regRequest?.header)!, fcparams: encoded)
            regResponse.assertions = [Assertions()]
            let jsonResponse = regResponse.toJSONArray()
            
            self.postRegRequest(json: jsonResponse as! [[String : AnyObject]]) { (postSuccessful, regOutcome) in
                guard (postSuccessful) else {
                    self.addText(field: self.infoTextLabel, text: "Post request unsuccessful")
                    return
                }
                self.addText(field: self.infoTextLabel, text: "Registration successful")
//                print(regOutcome.status)
            }
        }
    }
    
    //MARK: Helper methods
    
    func authenticateUsingTouchID(uuid: Data) {
        
        //Create authentication context
        let authenticationContext = LAContext()

        //Reason for biometrics authentication
        let reasonString = "Use TouchID to authorise signing"

        var authError: NSError? = nil

        guard #available(iOS 8.0, OSX 10.12, *) else {
            addText(field: self.infoTextLabel, text: "Too old operating system, please update ❌")
            return
        }

        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else {
            addText(field: self.infoTextLabel, text: "This device does not support TouchID")
            return
        }

        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: {(success, error) -> Void in
            if (success) {
                self.addText(field: self.infoTextLabel, text: "Signing authorised ✔")
                let privateKey = self.retrievePrivateKey(tag: self.tag)
                guard let publicKey = SecKeyCopyPublicKey(privateKey!) else {
                    self.addText(field: self.infoTextLabel, text: "Public key could not be retrieved ✔")
                    return
                }
                self.addText(field: self.infoTextLabel, text: "Public key retrieved ✔")
                
                // Sign number with private key
                let algorithm: SecKeyAlgorithm = .ecdsaSignatureDigestX962SHA256
                let signature = self.signChallenge(key: privateKey!, message: uuid as CFData, algorithm: algorithm)
                self.addText(field: self.infoTextLabel, text: "Challenge signed ✔")
                
                // Verify signature
                self.verifySignature(key: publicKey, signature: signature!, algorithm: algorithm, data: uuid as CFData)
                self.addText(field: self.infoTextLabel, text: "Signature verified ✔")

            }
            else {
                if error != nil {
                    self.addText(field: self.infoTextLabel, text: "Sorry, I do not recognize you ❌")
                }
            }
        })
    }
    
    func generateKeyPairAny() throws -> (privateKey: SecKey?, publicKey: SecKey?) {

        guard
            let access = SecAccessControlCreateWithFlags(
                kCFAllocatorDefault,
                kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                [.privateKeyUsage,.touchIDAny],
                nil
            ) else {
                addText(field: infoTextLabel, text: "could not create private key any error")
                return (nil, nil)
        }
        
        
        // private key parameters
        let privateKeyParams: [String: Any] = [
            kSecAttrAccessControl as String:    access,
            kSecAttrIsPermanent as String:      true,
            kSecAttrApplicationTag as String:   self.anytag
        ]
        
        
        // global parameters for our key generation
        let parameters: [String: Any] = [
            kSecAttrTokenID as String:          kSecAttrTokenIDSecureEnclave,
            kSecAttrKeyType as String:          kSecAttrKeyTypeEC,
            kSecAttrKeySizeInBits as String:    256,
            kSecPrivateKeyAttrs as String:      privateKeyParams
        ]
        
        
        guard
            let privateKey = SecKeyCreateRandomKey(parameters as CFDictionary, nil) else {
                print("ECC KeyGen Error!")
                return (nil, nil)
        }
        guard
            let publicKey = SecKeyCopyPublicKey(privateKey) else {
                print("ECC Pub KeyGen Error")
                return (nil, nil)
        }
        return (privateKey, publicKey)
    }
    
    func generateKeyPairCurrentSet() throws -> (privateKey: SecKey?, publicKey: SecKey?) {
        guard let access = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                           kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                           [.privateKeyUsage, .touchIDCurrentSet],
                                                           nil)
        else {
            addText(field: infoTextLabel, text: "Could not create private key current set")
            return (nil, nil)
        }

        let privateKeyParams: [String: Any] = [ kSecAttrIsPermanent     as String:  true,
                                              kSecAttrApplicationTag  as String:  self.currenttag,
                                              kSecAttrAccessControl   as String:  access ]
        
        let attributes: [String: Any] = [
            kSecAttrKeyType         as String:    kSecAttrKeyTypeEC,
            kSecAttrKeySizeInBits   as String:    256,
            kSecAttrTokenID         as String:    kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs     as String:    privateKeyParams ]
        var keyCreationError: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &keyCreationError)
            else {
                addText(field: infoTextLabel, text: "Error generating the key pair")
                throw keyCreationError!.takeRetainedValue() as Error
        }
        
        let publicKey = SecKeyCopyPublicKey(privateKey)
        return (privateKey, publicKey)
    }

    func retrievePrivateKey(tag: Data) -> SecKey? {
        let getquery: [String: Any] = [ kSecClass              as String:  kSecClassKey,
                                        kSecAttrApplicationTag as String:  tag,
                                        kSecAttrKeyType        as String:  kSecAttrKeyTypeEC,
                                        kSecReturnRef          as String:  true ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            self.addText(field: self.infoTextLabel, text: "Could not retrieve private key")
            return nil
        }
        let privateKey = item as! SecKey
        return privateKey
    }
    
    func signChallenge(key: SecKey, message: CFData, algorithm: SecKeyAlgorithm) -> CFData? {
        guard SecKeyIsAlgorithmSupported(key, .sign, algorithm) else {
            self.authenticateLabel.text = (self.authenticateLabel.text ?? "") + "Algorithm not supported by signing key ❌"
            return nil
        }
        
        var signingError: Unmanaged<CFError>?
        guard let signature = SecKeyCreateSignature(key, algorithm, message, &signingError) else {
            self.authenticateLabel.text = (self.authenticateLabel.text ?? "") + "Challenge could not be signed ❌"
            return nil
        }
        return signature
    }
    
    func verifySignature(key: SecKey, signature: CFData, algorithm: SecKeyAlgorithm, data: CFData) {
        guard SecKeyIsAlgorithmSupported(key, .verify, algorithm) else {
            self.authenticateLabel.text = (self.authenticateLabel.text ?? "") + "Algorithm not supported by verifying key ❌"
            return
        }
        var error: Unmanaged<CFError>?
        guard SecKeyVerifySignature(key, algorithm, data, signature, &error) else {
            self.authenticateLabel.text = (self.authenticateLabel.text ?? "") + "Signature corrupted ❌"
            return
        }
    }
    
    func addText(field: UILabel, text: String) {
        let string = "Step " + "\(step)" + ": " + text + "\n"
        DispatchQueue.main.async() { field.text?.append(string) }
        step += 1
    }
    
    func getRegRequest(taskCallback: @escaping (Bool, RegRequest?) -> ()) {
        var regRequest: RegRequest?
        let url = URL(string: "http://localhost:8080/v1/public/regRequest")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        Alamofire.request(request).responseJSON { response in
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
    
    func postRegRequest(json: [[String : AnyObject]], taskCallback: @escaping (Bool, RegOutcome) -> ()) {
        let url = URL(string: "http://localhost:8080/v1/public/regResponse")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"

        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = data
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        Alamofire.request(request).responseJSON { response in
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

    
