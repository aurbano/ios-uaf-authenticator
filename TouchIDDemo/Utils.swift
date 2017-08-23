//
//  Utils.swift
//  TouchIDDemo
//
//  Created by Iva on 22/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation

class Utils {
    private init() {}
    
    static func intToBytesArray(n: Int) -> Array<UInt8> {
        let hex = String(format: "%2X", n)
        let hexa = Array(hex.characters)
        let bytes = stride(from: 0, to: hex.characters.count, by: 2).flatMap { UInt8(String(hexa[$0..<$0.advanced(by: 2)]), radix: 16) }
        return bytes
    }
    
    static func hexToBytesArray(hex: String) -> Array<UInt8> {
        let hexa = Array(hex.characters)
        return stride(from: 0, to: hex.characters.count, by: 2).flatMap { UInt8(String(hexa[$0..<$0.advanced(by: 2)]), radix: 16) }
    }

    static func base64ToByteArray(fromString: String) -> Array<UInt8>? {
        guard let data = fromString.data(using: .utf8) else {
            print(ErrorString.Encoding.dataNotReadable)
            return nil
        }
        guard let decodedData = NSData(base64Encoded: data, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) else {
            print(ErrorString.Encoding.dataNotEncoded)
            return nil
        }
        
        let length = decodedData.length
        var byteout = Array<UInt8>(repeating: 0, count: length)
        decodedData.getBytes(&byteout, length: length)
                
        return byteout
    }
    
    static func signedToUnsignedArray(int8Array: Array<Int8>) -> Array<UInt8> {
        return int8Array.map{ UInt8(bitPattern: $0)}
    }
    
    static func unsignedToSignedArray(uint8Array: Array<UInt8>) -> Array<Int8> {
        return uint8Array.map{ Int8(bitPattern: $0)}
    }


}