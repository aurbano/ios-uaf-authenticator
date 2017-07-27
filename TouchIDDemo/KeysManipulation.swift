//
//  KeysManipulation.swift
//  TouchIDDemo
//
//  Created by Iva on 27/07/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation

class KeysManipulation {
    
    fuct createPair() {
        // Create public - private key pair
        let keyPair = self.generateKeyPair()
        if keyPair.publicKey != nil {
        keyCreationLabel.text = "Key created successfully"
        }
        
        // Generate random number to use as a challenge
        let uuid = UUID().uuidString
        
        // Sign the challenge using the private key
        let algorithm: SecKeyAlgorithm = .rsaSignatureDigestPKCS1v15SHA256

    }
}
