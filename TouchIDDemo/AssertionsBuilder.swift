//
//  AssertionsBuilder.swift
//  TouchIDDemo
//
//  Created by Iva on 14/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation

class AssertionBuilder {
    let DER_CERT = "MIIB-TCCAZ-gAwIBAgIEVTFM0zAJBgcqhkjOPQQBMIGEMQswCQYDVQQGEwJVUzELMAkGA1UECAwCQ0ExETAPBgNVBAcMCFNhbiBKb3NlMRMwEQYDVQQKDAplQmF5LCBJbmMuMQwwCgYDVQQLDANUTlMxEjAQBgNVBAMMCWVCYXksIEluYzEeMBwGCSqGSIb3DQEJARYPbnBlc2ljQGViYXkuY29tMB4XDTE1MDQxNzE4MTEzMVoXDTE1MDQyNzE4MTEzMVowgYQxCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJDQTERMA8GA1UEBwwIU2FuIEpvc2UxEzARBgNVBAoMCmVCYXksIEluYy4xDDAKBgNVBAsMA1ROUzESMBAGA1UEAwwJZUJheSwgSW5jMR4wHAYJKoZIhvcNAQkBFg9ucGVzaWNAZWJheS5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAAQ8hw5lHTUXvZ3SzY9argbOOBD2pn5zAM4mbShwQyCL5bRskTL3HVPWPQxqYVM-3pJtJILYqOWsIMd5Rb_h8D-EMAkGByqGSM49BAEDSQAwRgIhAIpkop_L3fOtm79Q2lKrKxea-KcvA1g6qkzaj42VD2hgAiEArtPpTEADIWz2yrl5XGfJVcfcFmvpMAuMKvuE1J73jp4"
    let PRIV_KEY_TAG = "com.ms.auth.ebay.testkey"

    
    func getAssertions(fc: String) -> String? {
        var byteout = Array<UInt8>()
        var value = Array<UInt8>()
        var length: Int = 0
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_UAFV1_REG_ASSERTION.rawValue))
        value = getRegAssertion(fc: fc)
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        let byteoutData = Data(byteout)
        
        let ret = byteoutData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return ret
    }
    
    internal func getRegAssertion(fc: String) -> Array<UInt8> {
        var byteout = Array<UInt8>()
        var value = Array<UInt8>()
        var length: Int = 0
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_UAFV1_KRD.rawValue))
        value = getSignedData(fc: fc)
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        let signedDataValue = byteout
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_ATTESTATION_BASIC_FULL.rawValue))
        value = getAttestationBasicFull(signedDataValue: signedDataValue)
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        return byteout
    }
    
    internal func getAttestationBasicFull(signedDataValue: Array<UInt8>) -> Array<UInt8> {
        var byteout = Array<UInt8>()
        var value = Array<UInt8>()
        var length: Int = 0
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_SIGNATURE.rawValue))
        value = getSignature(signedDataValue: signedDataValue)!
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_ATTESTATION_CERT.rawValue))
        value = base64ToByteArray(base64String: DER_CERT)!
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        return byteout
    }
    
    internal func getSignedData(fc: String) -> Array<UInt8> {
        var byteout = Array<UInt8>()
        var value = Array<UInt8>()
        var length: Int = 0
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_AAID.rawValue))
        value = Array<UInt8>(Assertion.AAID.utf8)
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_ASSERTION_INFO.rawValue))
        value = [0x00, 0x00, 0x01, 0x01, 0x00, 0x00, 0x01]
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_FINAL_CHALLENGE.rawValue))
        value = getFC(fc: fc)
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_KEYID.rawValue))
        value = getKeyId()!
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_COUNTERS.rawValue))
        value = getCounters()
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_PUB_KEY.rawValue))
        value = getPubKey()!
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        return byteout
    }
    
    internal func getSignature(signedDataValue: Array<UInt8>) -> Array<UInt8>? {
        let algorithm: SecKeyAlgorithm = .ecdsaSignatureMessageX962SHA256
        guard let privateKey = getPrivateKey(tag: PRIV_KEY_TAG.data(using: .ascii)!) else {
            print("Private key not retreieved")
            return nil
        }
        
        guard SecKeyIsAlgorithmSupported(privateKey, .sign, algorithm) else {
            print("Signing algorithm not supported")
            return nil
        }
        
        var signingError: Unmanaged<CFError>?
        let signedDataValueAsData = CFDataCreate(nil, signedDataValue, signedDataValue.count)
        guard let signature = SecKeyCreateSignature(privateKey, algorithm, signedDataValueAsData!, &signingError) else {
            print(signingError)
            print("Signing unsuccessful")
            return nil
        }
        
        let range = CFRangeMake(0, CFDataGetLength(signature))
        let byteptr = UnsafeMutablePointer<UInt8>.allocate(capacity: range.length)
        CFDataGetBytes(signature, range, byteptr)
        
        let byteout = Array(UnsafeBufferPointer(start: byteptr, count: range.length))
        
        return byteout
    }
    
    internal func getFC(fc: String) -> Array<UInt8> {
        let arr = Array<UInt8>(fc.utf8)
        return arr.sha256()
    }
    
    internal func getKeyId() -> Array<UInt8>? {
        let keyId = "ebay-test-key-" + (UUID().uuidString) as String
        
        let data = Array<UInt8>(keyId.utf8)
        let encoded = data.toBase64()
        let byteout = Array<UInt8>(encoded!.utf8)
        
        return byteout
    }
    
    internal func getCounters() -> Array<UInt8> {
        var byteout = Array<UInt8>()
        byteout.append(contentsOf: encodeInt(id: 0))
        byteout.append(contentsOf: encodeInt(id: 1))
        byteout.append(contentsOf: encodeInt(id: 0))
        byteout.append(contentsOf: encodeInt(id: 1))
        return byteout
    }
    
    internal func getPubKey() -> Array<UInt8>? {
        let pair = try? generateKeyPairCurrentSet()
        var pubKeyArray = Array<UInt8>()
        var error:Unmanaged<CFError>?
        if let cfdata = SecKeyCopyExternalRepresentation((pair?.publicKey!)!, &error) {
            let data:Data = cfdata as Data
            pubKeyArray = Array<UInt8>(data)
        }
        
        return pubKeyArray
    }
    
    internal func generateKeyPairCurrentSet() throws -> (privateKey: SecKey?, publicKey: SecKey?) {
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
                kSecAttrApplicationTag as String: PRIV_KEY_TAG,
                kSecAttrAccessControl as String:  access
            ]
        ]
        
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            print(error)
            print("Key pair not generated")
            throw error!.takeRetainedValue() as Error
        }
        
        guard
            let publicKey = SecKeyCopyPublicKey(privateKey) else {
                print("ECC Pub KeyGen Error")
                return (nil, nil)
        }
        return (privateKey, publicKey)
    }
    
    internal func getPrivateKey(tag: Data) -> SecKey? {
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
    
    internal func base64ToByteArray(base64String: String) -> Array<UInt8>? {
        guard let data = base64String.data(using: .utf8) else {
            print("Data not readable")
            return nil
        }
        guard let decodedData = NSData(base64Encoded: data, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) else {
            print("Data cannot be decoded")
            return nil
        }
        
        let length = decodedData.length
        var byteout = [UInt8](repeating: 0, count: length)
        decodedData.getBytes(&byteout, length: length)
        
        return byteout
    }
    
    internal func sha256(string: String) -> Array<UInt8> {
        let bytearr = Array<UInt8>(string.utf8)
        let hash = bytearr.sha256()
        return hash
    }
    
    internal func encodeInt(id: Int) -> Array<UInt8> {
        var bytes = Array<UInt8>()
        bytes.append(UInt8(id & 0x00ff))
        bytes.append(UInt8((id & 0xff00) >> 8))
        return bytes
    }
    
    internal func intToBytesArray(n: Int) -> Array<UInt8> {
        let hex = String(format: "%2X", n)
        let hexa = Array(hex.characters)
        let bytes = stride(from: 0, to: hex.characters.count, by: 2).flatMap { UInt8(String(hexa[$0..<$0.advanced(by: 2)]), radix: 16) }
        return bytes
    }
    
    internal func hexToBytesArray(hex: String) -> Array<UInt8> {
        let hexa = Array(hex.characters)
        return stride(from: 0, to: hex.characters.count, by: 2).flatMap { UInt8(String(hexa[$0..<$0.advanced(by: 2)]), radix: 16) }
    }
}
