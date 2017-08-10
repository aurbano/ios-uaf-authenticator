//
//  Assertions.swift
//  TouchIDDemo
//
//  Created by Iva on 10/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Gloss
import CryptoSwift

public class Assertions: Glossy {
    var assertionScheme: String?
    var assertion: String?
    
    init() {
        self.assertion = "AT7uAgM-sQALLgkAQUJDRCNBQkNEDi4HAAABAQEAAAEKLiAA9tBzZC64ecgVQBGSQb5QtEIPC8-Vav4HsHLZDflLaugJLiAAZMCPn92yHv1Ip-iCiBb6i4ADq6ZOv569KFQCvYSJfNgNLggAAQAAAAEAAAAMLkEABJsvEtUsVKh7tmYHhJ2FBm3kHU-OCdWiUYVijgYa81MfkjQ1z6UiHbKP9_nRzIN9anprHqDGcR6q7O20q_yctZAHPjUCBi5AACv8L7YlRMx10gPnszGO6rLFqZFmmRkhtV0TIWuWqYxd1jO0wxam7i5qdEa19u4sfpHFZ9RGI_WHxINkH8FfvAwFLu0BMIIB6TCCAY8CAQEwCQYHKoZIzj0EATB7MQswCQYDVQQGEwJVUzELMAkGA1UECAwCQ0ExCzAJBgNVBAcMAlBBMRAwDgYDVQQKDAdOTkwsSW5jMQ0wCwYDVQQLDAREQU4xMRMwEQYDVQQDDApOTkwsSW5jIENBMRwwGgYJKoZIhvcNAQkBFg1ubmxAZ21haWwuY29tMB4XDTE0MDgyODIxMzU0MFoXDTE3MDUyNDIxMzU0MFowgYYxCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJDQTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzEQMA4GA1UECgwHTk5MLEluYzENMAsGA1UECwwEREFOMTETMBEGA1UEAwwKTk5MLEluYyBDQTEcMBoGCSqGSIb3DQEJARYNbm5sQGdtYWlsLmNvbTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABCGBt3CIjnDowzSiF68C2aErYXnDUsWXOYxqIPim0OWg9FFdUYCa6AgKjn1R99Ek2d803sGKROivnavmdVH-SnEwCQYHKoZIzj0EAQNJADBGAiEAzAQujXnSS9AIAh6lGz6ydypLVTsTnBzqGJ4ypIqy_qUCIQCFsuOEGcRV-o4GHPBph_VMrG3NpYh2GKPjsAim_cSNmQ"
        self.assertionScheme = "UAFV1TLV"
    }
    
    required public init?(json: JSON) {
        self.assertionScheme = "assertionScheme" <~~ json
        self.assertion = "assertion" <~~ json
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            "assertionScheme" ~~> self.assertionScheme,
            "assertion" ~~> self.assertion
            ])
    }
}

class Assertion {
    var aaid: String?
    var assertionInfo: String?
    var finalChallenge: String?
    var keyID: String? // random
    var counter: Bool?
    var pubKey: String?
    let DER_CERT = "MIIB-TCCAZ-gAwIBAgIEVTFM0zAJBgcqhkjOPQQBMIGEMQswCQYDVQQGEwJVUzELMAkGA1UECAwCQ0ExETAPBgNVBAcMCFNhbiBKb3NlMRMwEQYDVQQKDAplQmF5LCBJbmMuMQwwCgYDVQQLDANUTlMxEjAQBgNVBAMMCWVCYXksIEluYzEeMBwGCSqGSIb3DQEJARYPbnBlc2ljQGViYXkuY29tMB4XDTE1MDQxNzE4MTEzMVoXDTE1MDQyNzE4MTEzMVowgYQxCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJDQTERMA8GA1UEBwwIU2FuIEpvc2UxEzARBgNVBAoMCmVCYXksIEluYy4xDDAKBgNVBAsMA1ROUzESMBAGA1UEAwwJZUJheSwgSW5jMR4wHAYJKoZIhvcNAQkBFg9ucGVzaWNAZWJheS5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAAQ8hw5lHTUXvZ3SzY9argbOOBD2pn5zAM4mbShwQyCL5bRskTL3HVPWPQxqYVM-3pJtJILYqOWsIMd5Rb_h8D-EMAkGByqGSM49BAEDSQAwRgIhAIpkop_L3fOtm79Q2lKrKxea-KcvA1g6qkzaj42VD2hgAiEArtPpTEADIWz2yrl5XGfJVcfcFmvpMAuMKvuE1J73jp4"
    
    func getAssertion(fc: String) -> String {
        //TODO: Get assertion
        return ""
    }
    
    internal func encodeInt(id: Int) -> Array<UInt8> {
        var bytes = Array<UInt8>()
        bytes[0] = UInt8(id & 0x00ff)
        bytes[1] = UInt8((id & 0x00ff) >> 8)
        return bytes
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
        value = getSignature(signedDataValue: signedDataValue)
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
        value = Array<UInt8>("EBA0#0001".utf8)
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
        value = getKeyId()
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_COUNTERS.rawValue))
        value = getCounters()
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_PUB_KEY.rawValue))
        value = getPubKey()
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        return Array<UInt8>()
    }
    
    internal func getSignature(signedDataValue: Array<UInt8>) -> Array<UInt8> {
        //TODO: SHA256 data for signing, then sign with private key RS
        //TODO: return signature to bytes
        return [UInt8]()
    }
    
    internal func getFC(fc: String) -> Array<UInt8> {
        let hash = sha256(string: fc)
        return hash
    }
    
    internal func getKeyId() -> Array<UInt8> {
        var byteout = Array<UInt8>()
        //TODO: keyid
        return Array<UInt8>()
    }
    
    internal func getCounters() -> Array<UInt8> {
        var byteout = Array<UInt8>()
        byteout.append(contentsOf: encodeInt(id: 0))
        byteout.append(contentsOf: encodeInt(id: 1))
        byteout.append(contentsOf: encodeInt(id: 0))
        byteout.append(contentsOf: encodeInt(id: 1))
        return byteout
    }
    
    internal func getPubKey() -> Array<UInt8> {
        guard let privateKey = getPrivateKey(tag: "com.ms.touchid.keys.testkey".data(using: .ascii)!) else {
            print("Could not retrieve private key")
            return Array<UInt8>()
        }
        
        var error: Unmanaged<CFError>?
        guard let publicKey = SecKeyCopyExternalRepresentation(privateKey, &error) else {
            print("Could not retrieve public key")
            return [UInt8]()
        }
        let pubKeyData = publicKey as Data
        let pubKeyArray = Array<UInt8>(pubKeyData)
        return pubKeyArray
    }
    
    internal func getPrivateKey(tag: Data) -> SecKey? {
        let getquery: [String: Any] = [ kSecClass              as String:  kSecClassKey,
                                        kSecAttrApplicationTag as String:  tag,
                                        kSecAttrKeyType        as String:  kSecAttrKeyTypeEC,
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
        let data = Array<UInt8>(base64String.utf8)
        guard let decoding = data.toBase64() else {
            print("Error while decoding")
            return Array<UInt8>()
        }
        let decoded = Array<UInt8>(decoding.utf8)
        return decoded
    }
    
    internal func sha256(string: String) -> Array<UInt8> {
        let bytearr = Array<UInt8>(string.utf8)
        let hash = bytearr.sha256()
        return hash
    }
    
}
