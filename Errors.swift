//
//  ErrorMessage.swift
//  TouchIDDemo
//
//  Created by Iva on 16/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation

struct ErrorString {
    
    struct Keys {
        static let KeyPairNotGenerated = "Key pair not generated"
        static let pubKeyNotCopied = "Public key not found for the corresponding private key"
        static let privKeyNotRetrieved = "Private key not retreieved"
        static let algoNotSupported = "Signing algorithm not supported"
        static let usuccessfulSign = "Signing unsuccessful"
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
        static let regFail = "Unable to register."
        static let authSuccess = "Logged in"
    }
}
