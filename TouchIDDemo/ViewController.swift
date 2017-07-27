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
    @IBOutlet weak var keyCreationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func authenticateButton(_ sender: UIButton) {
        
//        // Create public - private key pair
//        let keyPair = try? self.generateKeyPair()
//        if keyPair?.publicKey != nil {
//            self.authenticateLabel.text = "Key created successfully"
//        }
        
        //Get the public key
        let tag = "com.ms.touchid.keys.testkey".data(using: .ascii)!
        let privateKey = retrievePrivateKey(tag: tag)
        guard let publicKey = SecKeyCopyPublicKey(privateKey!) else {
            self.authenticateLabel.text = "Public key could not be retrieved"
            return
        }

        // Generate random number to use as a challenge
        let uuid = UUID().uuidString.data(using: .ascii)
        
        // Sign number with private key
        let algorithm: SecKeyAlgorithm = .ecdsaSignatureDigestX962SHA256
        let signature = signChallenge(key: privateKey!, message: uuid! as CFData, algorithm: algorithm)
        self.authenticateLabel.text = "Challenge signed"

        // Verify signature
        verifySignature(key:publicKey, signature: signature!, algorithm: algorithm, data: uuid! as CFData)

    }
    
    func authenticateUsingTouchID() {
        //Create authentication context
        let authenticationContext = LAContext()

        //Reason for biometrics authentication
        let reasonString = "I need to steal your fingerprint"

        var authError: NSError? = nil

        guard #available(iOS 8.0, OSX 10.12, *) else {
            DispatchQueue.main.async() { self.authenticateLabel.text = "Too old operating system, please update" }
            return
        }

        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else {
            DispatchQueue.main.async() { self.authenticateLabel.text = "This device does not support TouchID" }
            return
        }

        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: {(success, error) -> Void in
            if (success) {
                DispatchQueue.main.async() { self.authenticateLabel.text = "Authenticated" }
            }
            else {
                if error != nil {
                    DispatchQueue.main.async() { self.authenticateLabel.text = "Sorry, I do not recognize you" }
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
                self.authenticateLabel.text = "Error generating the key pair"
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
            self.authenticateLabel.text = "Could not retrieve private key"
            return nil
        }
        let privateKey = item as! SecKey
        return privateKey
    }
    
    func signChallenge(key: SecKey, message: CFData, algorithm: SecKeyAlgorithm) -> CFData? {
        guard SecKeyIsAlgorithmSupported(key, .sign, algorithm) else {
            self.authenticateLabel.text = "Algorithm not supported by signing key"
            return nil
        }
        
        var signingError: Unmanaged<CFError>?
        guard let signature = SecKeyCreateSignature(key, algorithm, message, &signingError) else {
            self.authenticateLabel.text = "Challenge could not be signed"
            return nil
        }
        return signature
    }
    
    func verifySignature(key: SecKey, signature: CFData, algorithm: SecKeyAlgorithm, data: CFData) {
        guard SecKeyIsAlgorithmSupported(key, .verify, algorithm) else {
            self.authenticateLabel.text = "Algorithm not supported by verifying key"
            return
        }
        var error: Unmanaged<CFError>?
        guard SecKeyVerifySignature(key, algorithm, data, signature, &error) else {
            self.authenticateLabel.text = "Signature corrupted"
            return
        }
        
        self.authenticateLabel.text = "Signature verified!"
        
    }
}

    
