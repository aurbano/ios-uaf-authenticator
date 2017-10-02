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
            print(MessageString.Encoding.dataNotReadable)
            return nil
        }
        guard let decodedData = NSData(base64Encoded: data, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) else {
            print(MessageString.Encoding.dataNotEncoded)
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

    static func getNewKeyTag(username: String, environment: String) -> String {
        let timestamp = NSDate.timeIntervalSinceReferenceDate
        let tag = username + "-" + environment + "-" + String(timestamp)
        return tag
    }

    static func buildFcParams(request: GetRequest?) -> String {
        let appid = "{\n\"appID\": \"" + (request?.header?.appId)! + "\",\n"
        let facetid = "\"facetID\": \"http://ms.com\",\n"
        let challenge = "\"challenge\": \"" + (request?.challenge)! + "\"\n}"
        return (appid + facetid + challenge)
    }
    
    static func buildFcParams(challenge: String) -> String {
        let appid = "{\n\"appID\": \"" + Constants.appID + "\",\n"
        let facetid = "\"facetID\": \"http://ms.com\",\n"
        let challenge = "\"challenge\": \"" + (challenge) + "\"\n}"
        return (appid + facetid + challenge)
    }
    
    static func parseScannedData(data: String) -> (challenge: String, serverData: String, url: String)? {
        let stripped = data.replacingOccurrences(of: "\"", with: "")
        let lines = stripped.components(separatedBy: ",")
        let challenge = lines[0]
        let serverData = lines[1]
        let url = lines[2]
        
        return (challenge, serverData, url)
    }
    
    static func parseRegURL(url: String) -> String {
        var params = [String: String]()
        let index = url.index(url.startIndex, offsetBy: 7)
        let query = url.substring(from: index)

        let pairs = query.components(separatedBy: "&")
        
        for pair in pairs {
            let split = pair.components(separatedBy: "=")
            params[split[0]] = split[1]
        }
        
        let string = params["challenge"]! + "," + params["serverData"]! + "," + params["url"]!
        return string
    }
}
