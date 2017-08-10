//
//  RegRequest.swift
//  TouchIDDemo
//
//  Created by Iva on 04/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Gloss
import CryptoSwift

class RegResponse: Glossy {
    var header: Header? = nil
    var fcparams: String? = nil
    var assertions: [Assertions]? = nil
    
    init(header: Header, fcparams: String) {
        self.header = header
        self.fcparams = fcparams
    }
    
    required init?(json: JSON) {
        self.header = "header" <~~ json
        self.fcparams = "fcParams" <~~ json
        self.assertions = "assertions" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "header" ~~> self.header,
            "fcParams" ~~> self.fcparams,
            "assertions" ~~> self.assertions,
        ])
    }
    
    func toJSONArray() -> [JSON?] {
        return [toJSON()]
    }

}

class Header: Glossy {
    var upv: Upv? = nil
    var op: String? = nil
    var appId: String? = "http://localhost:8080/v1/public/uaf/facets"
    var serverData: String? = nil
    
    required init?(json: JSON) {
        self.upv = "upv" <~~ json
        self.op = "op" <~~ json
        self.appId = "appID" <~~ json
        self.serverData = "serverData" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "upv" ~~> self.upv,
            "op" ~~> self.op,
            "appId" ~~> self.appId,
            "serverData" ~~> self.serverData
        ])
    }
}

class Upv: Glossy {
    var major: Int? = 1
    var minor: Int? = 0
    
    required init?(json: JSON) {
        self.major = "major" <~~ json
        self.minor = "minor" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "major" ~~> self.major,
            "minor" ~~> self.minor
        ])
    }
}

class Assertions: Glossy {
    var assertionScheme: String?
    var assertion: String?
    
    init() {
        self.assertion = "AT7uAgM-sQALLgkAQUJDRCNBQkNEDi4HAAABAQEAAAEKLiAA9tBzZC64ecgVQBGSQb5QtEIPC8-Vav4HsHLZDflLaugJLiAAZMCPn92yHv1Ip-iCiBb6i4ADq6ZOv569KFQCvYSJfNgNLggAAQAAAAEAAAAMLkEABJsvEtUsVKh7tmYHhJ2FBm3kHU-OCdWiUYVijgYa81MfkjQ1z6UiHbKP9_nRzIN9anprHqDGcR6q7O20q_yctZAHPjUCBi5AACv8L7YlRMx10gPnszGO6rLFqZFmmRkhtV0TIWuWqYxd1jO0wxam7i5qdEa19u4sfpHFZ9RGI_WHxINkH8FfvAwFLu0BMIIB6TCCAY8CAQEwCQYHKoZIzj0EATB7MQswCQYDVQQGEwJVUzELMAkGA1UECAwCQ0ExCzAJBgNVBAcMAlBBMRAwDgYDVQQKDAdOTkwsSW5jMQ0wCwYDVQQLDAREQU4xMRMwEQYDVQQDDApOTkwsSW5jIENBMRwwGgYJKoZIhvcNAQkBFg1ubmxAZ21haWwuY29tMB4XDTE0MDgyODIxMzU0MFoXDTE3MDUyNDIxMzU0MFowgYYxCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJDQTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzEQMA4GA1UECgwHTk5MLEluYzENMAsGA1UECwwEREFOMTETMBEGA1UEAwwKTk5MLEluYyBDQTEcMBoGCSqGSIb3DQEJARYNbm5sQGdtYWlsLmNvbTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABCGBt3CIjnDowzSiF68C2aErYXnDUsWXOYxqIPim0OWg9FFdUYCa6AgKjn1R99Ek2d803sGKROivnavmdVH-SnEwCQYHKoZIzj0EAQNJADBGAiEAzAQujXnSS9AIAh6lGz6ydypLVTsTnBzqGJ4ypIqy_qUCIQCFsuOEGcRV-o4GHPBph_VMrG3NpYh2GKPjsAim_cSNmQ"
        self.assertionScheme = "UAFV1TLV"
    }
    
    required init?(json: JSON) {
        self.assertionScheme = "assertionScheme" <~~ json
        self.assertion = "assertion" <~~ json
    }
    
    func toJSON() -> JSON? {
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
    let PRIV_KEY_TAG = "com.ms.touchid.keys.testkey"

    
    func getAssertion(fc: String) -> String {
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
            print("Private key could not be retreieved")
            return nil
        }
        
        guard SecKeyIsAlgorithmSupported(privateKey, .sign, algorithm) else {
            print("Signing algorithm not supported")
            return nil
        }
        
        var signingError: Unmanaged<CFError>?
        guard let signature = SecKeyCreateSignature(privateKey, algorithm, signedDataValue as! CFData, &signingError) else {
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
        return sha256(string: fc)
    }
    
    internal func getKeyId() -> Array<UInt8>? {
        let keyId = "ebay-test-key-" + (UUID().uuidString) as String
        guard let byteout = base64ToByteArray(base64String: keyId) else {
            print("Encryption unsuccessful")
            return nil
        }
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
        guard let privateKey = getPrivateKey(tag: PRIV_KEY_TAG.data(using: .ascii)!) else {
            print("Could not retrieve private key")
            return nil
        }
        
        var error: Unmanaged<CFError>?
        guard let publicKey = SecKeyCopyExternalRepresentation(privateKey, &error) else {
            print("Could not retrieve public key")
            return nil
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
        let data = String()
        guard let decoding = try? base64String.decryptBase64ToString(cipher: data as! Cipher) else {
            print("Error while decoding")
            return nil
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

enum Tags: Int {
    case UAF_CMD_STATUS_ERR_UNKNOWN = 0x01
    case TAG_UAFV1_REG_ASSERTION = 0x3E01
    case TAG_UAFV1_AUTH_ASSERTION = 0x3E02
    case TAG_UAFV1_KRD = 0x3E03
    case TAG_UAFV1_SIGNED_DATA = 0x3E04
    case TAG_ATTESTATION_CERT = 0x2E05
    case TAG_SIGNATURE = 0x2E06
    case TAG_ATTESTATION_BASIC_FULL = 0x3E07
    case TAG_ATTESTATION_BASIC_SURROGATE = 0x3E08
    case TAG_KEYID = 0x2E09
    case TAG_FINAL_CHALLENGE = 0x2E0A
    case TAG_AAID = 0x2E0B
    case TAG_PUB_KEY = 0x2E0C
    case TAG_COUNTERS = 0x2E0D
    case TAG_ASSERTION_INFO = 0x2E0E
    case TAG_AUTHENTICATOR_NONCE = 0x2E0F
    case TAG_TRANSACTION_CONTENT_HASH = 0x2E10
    case TAG_EXTENSION = 0x3E11
    case TAG_EXTENSION_NON_CRITICAL = 0x3E12
    case TAG_EXTENSION_ID = 0x2E13
    case TAG_EXTENSION_DATA = 0x2E14

}
