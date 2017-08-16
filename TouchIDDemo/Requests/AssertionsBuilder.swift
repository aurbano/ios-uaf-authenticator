//
//  AssertionsBuilder.swift
//  TouchIDDemo
//
//  Created by Iva on 14/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation

class AssertionBuilder {
    private let privKeyTag: String
    private let keys = KeysManipulation()
    
    init() {
        privKeyTag = Constants.privateKeyTestTag
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
        value = getSignature(signedDataValue: signedDataValue)!
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_ATTESTATION_CERT.rawValue))
        value = base64ToByteArray(base64String: Constants.derCert)!
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
        value = getPubKey()!
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        return byteout
    }
    
    private func getSignature(signedDataValue: Array<UInt8>) -> Array<UInt8>? {
        let algorithm: SecKeyAlgorithm = .ecdsaSignatureMessageX962SHA256
        guard let privateKey = getPrivateKey(tag: self.privKeyTag) else {
            print(ErrorString.Keys.privKeyNotRetrieved)
            return nil
        }
        
        guard SecKeyIsAlgorithmSupported(privateKey, .sign, algorithm) else {
            print(ErrorString.Keys.algoNotSupported)
            return nil
        }
        
        var signingError: Unmanaged<CFError>?
        let signedDataValueAsData = CFDataCreate(nil, signedDataValue, signedDataValue.count)
        guard let signature = SecKeyCreateSignature(privateKey, algorithm, signedDataValueAsData!, &signingError) else {
            print(signingError)
            print(ErrorString.Keys.usuccessfulSign)
            return nil
        }
        
        let range = CFRangeMake(0, CFDataGetLength(signature))
        let byteptr = UnsafeMutablePointer<UInt8>.allocate(capacity: range.length)
        CFDataGetBytes(signature, range, byteptr)
        
        let byteout = Array(UnsafeBufferPointer(start: byteptr, count: range.length))
        
        return byteout
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
    
    private func getPubKey() -> Array<UInt8>? {
        let pair = try! self.generateKeyPair()

        var pubKeyArray = Array<UInt8>()
        var error:Unmanaged<CFError>?
        if let cfdata = SecKeyCopyExternalRepresentation((pair.publicKey!), &error) {
            let data:Data = cfdata as Data
            pubKeyArray = Array<UInt8>(data)
        }
        
        return pubKeyArray
    }
    
    private func generateKeyPair() throws -> (privateKey: SecKey?, publicKey: SecKey?) {
        return try! keys.generateKeyPair(tag: self.privKeyTag)
    }
    
    func getPrivateKey(tag: String) -> SecKey? {
        return keys.getPrivateKeyRef(tag: tag)
    }
    
    private func base64ToByteArray(base64String: String) -> Array<UInt8>? {
        guard let data = base64String.data(using: .utf8) else {
            print(ErrorString.Encoding.dataNotReadable)
            return nil
        }
        guard let decodedData = NSData(base64Encoded: data, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) else {
            print(ErrorString.Encoding.dataNotEncoded)
            return nil
        }
        
        let length = decodedData.length
        var byteout = [UInt8](repeating: 0, count: length)
        decodedData.getBytes(&byteout, length: length)
        
        return byteout
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
    
    private func intToBytesArray(n: Int) -> Array<UInt8> {
        let hex = String(format: "%2X", n)
        let hexa = Array(hex.characters)
        let bytes = stride(from: 0, to: hex.characters.count, by: 2).flatMap { UInt8(String(hexa[$0..<$0.advanced(by: 2)]), radix: 16) }
        return bytes
    }
    
    private func hexToBytesArray(hex: String) -> Array<UInt8> {
        let hexa = Array(hex.characters)
        return stride(from: 0, to: hex.characters.count, by: 2).flatMap { UInt8(String(hexa[$0..<$0.advanced(by: 2)]), radix: 16) }
    }
}
