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
        let myContext = LAContext()
        var authError: NSError? = nil
        if myContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            guard let access = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                               kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                               [.privateKeyUsage, .touchIDCurrentSet],
                                                               nil)
            else {
                print(MessageString.Keys.KeyPairNotGenerated)
                return (nil, nil)
            }

            let privateKeyParams: [String: Any] = [ kSecAttrIsPermanent     as String:  true,
                                                  kSecAttrApplicationTag  as String:  tag,
                                                  kSecAttrAccessControl   as String:  access ]

            let attributes: [String: Any] = [
                kSecAttrKeyType         as String:    kSecAttrKeyTypeEC,
                kSecAttrKeySizeInBits   as String:    256,
                kSecAttrTokenID         as String:    kSecAttrTokenIDSecureEnclave,
                kSecPrivateKeyAttrs     as String:    privateKeyParams ]
            
            var keyCreationError: Unmanaged<CFError>?
            guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &keyCreationError)
                else {
                    print(MessageString.Keys.KeyPairNotGenerated)
                    throw keyCreationError!.takeRetainedValue() as Error
            }

            let publicKey = SecKeyCopyPublicKey(privateKey)
            return (privateKey, publicKey)
        }
        else {
        // -------------- Regular key pair --------------
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
                print(MessageString.Keys.KeyPairNotGenerated)
                throw error!.takeRetainedValue() as Error
            }
            
            guard let data = SecKeyCopyExternalRepresentation(privateKey, &error) else {
                print(error)
                return (nil, nil)
            }
            let str = String(data: data as Data, encoding: .utf8)
            
            let publicKey = getPublicKeybyPrivate(privateKey: privateKey)
            return (privateKey, publicKey)
        }
    }
    
    func getKeyPair(tag: String) -> (SecKey?, SecKey?) {
        let getquery: [String: Any] = [ kSecClass              as String:  kSecClassKey,
                                        kSecAttrApplicationTag as String:  tag,
                                        kSecAttrKeyType        as String:  kSecAttrKeyTypeECSECPrimeRandom,
                                        kSecReturnRef          as String:  true ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            print(MessageString.Keys.privKeyNotRetrieved)
            return (nil, nil)
        }
        let privateKey = item as! SecKey
        
        let publicKey = getPublicKeybyPrivate(privateKey: privateKey)
        
        return (privateKey, publicKey)
    }

    func getPublicKeybyPrivate(privateKey: SecKey) -> SecKey? {
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
                print(MessageString.Keys.pubKeyNotCopied)
                return nil
        }
        return publicKey
    }

    func signData(dataForSigning: Array<UInt8>, key: SecKey, algorithm: SecKeyAlgorithm) -> Array<UInt8>? {
        guard SecKeyIsAlgorithmSupported(key, .sign, algorithm) else {
            print(MessageString.Keys.algoNotSupported)
            return nil
        }
        
        var signingError: Unmanaged<CFError>?
        let signedDataValueAsData = CFDataCreate(nil, dataForSigning, dataForSigning.count)
        guard let signature = SecKeyCreateSignature(key, algorithm, signedDataValueAsData!, &signingError) else {
            print(signingError)
            print(MessageString.Keys.usuccessfulSign)
            return nil
        }
        
        let publicKey = getPublicKeybyPrivate(privateKey: key)
        self.verifySignature(key: publicKey!, signature: signature, algorithm: algorithm, data: signedDataValueAsData!)

        let range = CFRangeMake(0, CFDataGetLength(signature))
        let byteptr = UnsafeMutablePointer<UInt8>.allocate(capacity: range.length)
        CFDataGetBytes(signature, range, byteptr)
        
        let byteout = Array(UnsafeBufferPointer(start: byteptr, count: range.length))
        
        return byteout

    }
    
    func verifySignature(key: SecKey, signature: CFData, algorithm: SecKeyAlgorithm, data: CFData) {
        guard SecKeyIsAlgorithmSupported(key, .verify, algorithm) else {
            print(MessageString.Keys.algorithmNotSupported)
            return
        }
        var error: Unmanaged<CFError>?
        guard SecKeyVerifySignature(key, algorithm, data, signature, &error) else {
            print(MessageString.Keys.signatureCorrupted)
            return
        }
        
        print(MessageString.Keys.signatureVerified)
    }

}
