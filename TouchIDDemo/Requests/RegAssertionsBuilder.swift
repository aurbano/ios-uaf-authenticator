//
//  AssertionsBuilder.swift
//  TouchIDDemo
//
//  Created by Iva on 14/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import CryptoSwift

class RegAssertionBuilder {
    private let privKeyTag: String
    private let keys: KeysManipulation
    var keyID: Array<UInt8>
    private let pair: (privateKey: SecKey?, publicKey: SecKey?)
    
    init(username: String, environment: String) {
        privKeyTag = Utils.getNewKeyTag(username: username, environment: environment)
        keys = KeysManipulation()
        keyID = Array<UInt8>()
        self.pair = try! keys.generateKeyPair(tag: privKeyTag)
    }
    
    func getPrivKeyTag() -> String {
        return privKeyTag
    }
    
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
    
    private func getRegAssertion(fc: String) -> Array<UInt8> {
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
    
    private func getAttestationBasicFull(signedDataValue: Array<UInt8>) -> Array<UInt8> {
        var byteout = Array<UInt8>()
        var value = Array<UInt8>()
        var length: Int = 0
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_SIGNATURE.rawValue))
        value = getSignature(signedDataValue: signedDataValue)
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
                
        return byteout
    }
    
    private func getSignedData(fc: String) -> Array<UInt8> {
        var byteout = Array<UInt8>()
        var value = Array<UInt8>()
        var length: Int = 0
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_AAID.rawValue))
        value = Array<UInt8>(Constants.aaid.utf8)
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_ASSERTION_INFO.rawValue))
        value = Constants.assertionInfo
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
        value = getPubKeyAsArray()!
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        return byteout
    }
    
    private func getSignature(signedDataValue: Array<UInt8>) -> Array<UInt8> {
        let algorithm: SecKeyAlgorithm = .ecdsaSignatureMessageX962SHA256
        
        let signature = keys.signData(dataForSigning: signedDataValue, key: self.pair.privateKey!, algorithm: algorithm)
        return signature
        
    }
    
    private func getFC(fc: String) -> Array<UInt8> {
        let arr = Array<UInt8>(fc.utf8)
        return arr.sha256()
    }
    
    private func getKeyId() -> Array<UInt8>? {
        let keyId = (UUID().uuidString) as String
        
        let data = Array<UInt8>(keyId.utf8)
        let encoded = data.toBase64()
        let byteout = Array<UInt8>(encoded!.utf8)
        self.keyID = byteout
        
        return byteout
    }
    
    private func getCounters() -> Array<UInt8> {
        var byteout = Array<UInt8>()
        byteout.append(contentsOf: encodeInt(id: 0))
        byteout.append(contentsOf: encodeInt(id: 1))
        byteout.append(contentsOf: encodeInt(id: 0))
        byteout.append(contentsOf: encodeInt(id: 1))
        return byteout
    }
    
    private func getPubKeyAsArray() -> Array<UInt8>? {
        let pubKey = self.pair.publicKey

        var pubKeyArray = Array<UInt8>()
        var error:Unmanaged<CFError>?
        
        if let cfdata = SecKeyCopyExternalRepresentation((pubKey!), &error) {
            let data:Data = cfdata as Data
            pubKeyArray = Array<UInt8>(data)
        }
        return pubKeyArray
    }
        
    private func sha256(string: String) -> Array<UInt8> {
        let bytearr = Array<UInt8>(string.utf8)
        let hash = bytearr.sha256()
        return hash
    }
    
    private func encodeInt(id: Int) -> Array<UInt8> {
        var bytes = Array<UInt8>()
        bytes.append(UInt8(id & 0x00ff))
        bytes.append(UInt8((id & 0xff00) >> 8))
        return bytes
    }
    
}
