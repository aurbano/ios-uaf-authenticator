//
//  ViewController.swift
//  TouchIDDemo
//
//  Created by Iva on 24/07/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import UIKit
import LocalAuthentication

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func authenticateButton(_ sender: UIButton) {
        step = 1
        
//        // Create public - private key pair
//        let keyPair = try? self.generateKeyPair()
//        if keyPair?.publicKey != nil {
//            self.authenticateLabel.text = (self.authenticateLabel.text ?? "") + "\nKey created successfully"
//        }
        
        // Generate random number to use as a challenge
        let uuid = UUID().uuidString.data(using: .ascii)
        addText(field: self.infoTextLabel, text: "Challenge created ✔")

        //Get the public key
        authenticateUsingTouchID(uuid: uuid!)
//        addText(field: self.infoTextView, text:"Private key reference retrieved")
    }
    
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

    
    func generateKeyPair() throws -> (privateKey: SecKey?, publicKey: SecKey?) {
        let access = SecAccessControlCreateWithFlags(kCFAllocatorDefault, kSecAttrAccessibleWhenUnlockedThisDeviceOnly,.privateKeyUsage, nil)!
        let tag = "com.ms.touchid.keys.testkey".data(using: .utf8)!
        let attributes: [String: Any] = [
            kSecAttrKeyType         as String:    kSecAttrKeyTypeEC,
            kSecAttrKeySizeInBits   as String:    256,
            kSecAttrTokenID         as String:    kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs     as String:    [ kSecAttrIsPermanent     as String:  true,
                                                    kSecAttrApplicationTag  as String:  tag,
                                                    kSecAttrAccessControl   as String:  access ]
        ]
        var keyCreationError: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &keyCreationError)
            else {
                self.authenticateLabel.text = (self.authenticateLabel.text ?? "") + "Error generating the key pair ❌"
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
            self.authenticateLabel.text = (self.authenticateLabel.text ?? "") + "Could not retrieve private key ❌"
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
}

    
