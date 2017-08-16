//
//  KeysManipulation.swift
//  TouchIDDemo
//
//  Created by Iva on 27/07/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import LocalAuthentication

class KeysManipulation {    
    func generateKeyPair(tag: String) throws -> (privateKey: SecKey?, publicKey: SecKey?) {
        let access =
            SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                            .privateKeyUsage,
                                            nil)!   // Ignore error
        
        
        let attributes: [String: Any] = [
            kSecAttrKeyType as String:            kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String:      256,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String:    true,
                kSecAttrApplicationTag as String: tag,
                kSecAttrAccessControl as String:  access
            ]
        ]
        
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            print(error)
            print(ErrorString.Keys.KeyPairNotGenerated)
            throw error!.takeRetainedValue() as Error
        }
        
        guard
            let publicKey = SecKeyCopyPublicKey(privateKey) else {
                print(ErrorString.Keys.pubKeyNotCopied)
                return (nil, nil)
        }
        return (privateKey, publicKey)
    }
    
    func getPrivateKeyRef(tag: String) -> SecKey? {
        let getquery: [String: Any] = [ kSecClass              as String:  kSecClassKey,
                                        kSecAttrApplicationTag as String:  tag,
                                        kSecAttrKeyType        as String:  kSecAttrKeyTypeECSECPrimeRandom,
                                        kSecReturnRef          as String:  true ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            return nil
        }
        let privateKey = item as! SecKey
        return privateKey
    }

//    // Generate random number to use as a challenge
//        let uuid = UUID().uuidString
//        
//        // Sign the challenge using the private key
//        let algorithm: SecKeyAlgorithm = .rsaSignatureDigestPKCS1v15SHA256

}
