//
//  AuthAssertionBuilder.swift
//  TouchIDDemo
//
//  Created by Iva on 18/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation

class AuthAssertionBuilder {
    private let privKeyTag: String
    private let keys: KeysManipulation
    private let keyID: Array<UInt8>
    private let pair: (privateKey: SecKey?, publicKey: SecKey?)

    init(keyTag: String, keyID: Array<UInt8>) {
        self.privKeyTag = keyTag
        self.keyID = keyID
        
        keys = KeysManipulation()
        pair = keys.getKeyPair(tag: keyTag)
    }
    
    func getPrivKeyTag() -> String {
        return privKeyTag
    }

    func getAssertions(fcParams: String) -> String? {
        var byteout = Array<UInt8>()
        var value = Array<UInt8>()
        var length: Int = 0

        byteout.append(contentsOf: encodeInt(id: Tags.TAG_UAFV1_AUTH_ASSERTION.rawValue))
        value = getAuthAssertion(fcParams: fcParams)
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        let ret = byteout.toBase64()
        return ret
    }
    
    private func getAuthAssertion(fcParams: String) -> Array<UInt8> {
        var byteout = Array<UInt8>()
        var value = Array<UInt8>()
        var length: Int = 0

        byteout.append(contentsOf: encodeInt(id: Tags.TAG_UAFV1_SIGNED_DATA.rawValue))
        value = getSignedData(fcParams: fcParams)
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        let signedDataValue = byteout
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_SIGNATURE.rawValue))
        value = getSignature(signedDataValue: signedDataValue)!
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        return byteout
    }
    
    private func getSignedData(fcParams: String) -> Array<UInt8> {
        var byteout = Array<UInt8>()
        var value = Array<UInt8>()
        var length: Int = 0

        byteout.append(contentsOf: encodeInt(id: Tags.TAG_AAID.rawValue))
        value = Array<UInt8>(Constants.aaid.utf8)
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_ASSERTION_INFO.rawValue))
        value = getAssertionInfo()
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_AUTHENTICATOR_NONCE.rawValue))
        value = getNonce()
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)
        
        byteout.append(contentsOf: encodeInt(id: Tags.TAG_FINAL_CHALLENGE.rawValue))
        value = getFC(fcParams: fcParams)
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)

        byteout.append(contentsOf: encodeInt(id: Tags.TAG_TRANSACTION_CONTENT_HASH.rawValue))
        length = 0
        byteout.append(contentsOf: encodeInt(id: length))

        byteout.append(contentsOf: encodeInt(id: Tags.TAG_KEYID.rawValue))
        value = self.keyID
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)

        byteout.append(contentsOf: encodeInt(id: Tags.TAG_COUNTERS.rawValue))
        value = getCounters()
        length = value.count
        byteout.append(contentsOf: encodeInt(id: length))
        byteout.append(contentsOf: value)

        return byteout
    }
    
    private func getFC(fcParams: String) -> Array<UInt8> {
        let array = Array<UInt8>(fcParams.utf8)
        return array.sha256()
    }
    
    private func getCounters() -> Array<UInt8> {
        var byteout = Array<UInt8>()
        byteout.append(contentsOf: encodeInt(id: 0))
        byteout.append(contentsOf: encodeInt(id: 1))
        return byteout

    }
    
    private func getSignature(signedDataValue: Array<UInt8>) -> Array<UInt8>? {
        let algorithm: SecKeyAlgorithm = .ecdsaSignatureMessageX962SHA256
        
        let signatute = keys.signData(dataForSigning: signedDataValue, key: self.pair.privateKey!, algorithm: algorithm)
        return signatute
    }
        
    private func getNonce() -> Array<UInt8> {
        let nonce = UUID().uuidString
        let bytearray = Array<UInt8>(nonce.utf8)
        return bytearray.sha256()
    }
    
    private func getAssertionInfo() -> Array<UInt8> {
        return Array<UInt8>(Constants.assertionInfo[0...4])
    }
    
    private func encodeInt(id: Int) -> Array<UInt8> {
        var bytes = Array<UInt8>()
        bytes.append(UInt8(id & 0x00ff))
        bytes.append(UInt8((id & 0xff00) >> 8))
        return bytes
    }

}
