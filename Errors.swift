//
//  ErrorMessage.swift
//  TouchIDDemo
//
//  Created by Iva on 16/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation

struct MessageString {
    
    struct Keys {
        static let KeyPairNotGenerated = "Key pair not generated"
        static let pubKeyNotCopied = "Public key not found for the corresponding private key"
        static let privKeyNotRetrieved = "Private key not retreieved"
        static let algoNotSupported = "Signing algorithm not supported"
        static let usuccessfulSign = "Signing unsuccessful"
        static let algorithmNotSupported = "Algorithm not supported by verifying key"
        static let signatureCorrupted = "Signature could not be verified with public key"
        static let signatureVerified = "Signature verified with public key"
    }
    
    struct Encoding {
        static let dataNotReadable = "Data not readable"
        static let dataNotEncoded = "Data cannot be decoded"
        static let unableToDecode = "Unable to decode property: "
    }
    
    struct Requests {
        static let postFail = "Post request unsuccessful"
        static let getFail = "Get request unsuccessful"
    }
    
    struct Info {
        static let regSuccess = "Registration successful!"
        static let regSavedSuccess = "Registration data saved successfully"
        static let regSavedFail = "Failed to save registration data"
        static let regLoadFail = "Registrations not loaded correctly"
        static let regFail = "Registration failed"
        static let authSuccess = "Logged in"
        static let txFail = "Transaction signing failed"
        static let txSuccess = "Transaction signing successful"
        static let refreshFail = "Retrieving pending transactions failed. \nTry again later"
    }
    
    struct Labels {
        static let company = "Company: "
        static let value = "Value: "
        static let date = "Date: "
        static let content = "Contents: "
    }
    
    struct Server {
        static let declinedTx = "DECLINED_TX"
        static let signedTx = "SIGNED_TX"
        static let qrNotParsed = "Unable to parse data from QR code"
    }
}
