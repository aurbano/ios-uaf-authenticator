//
//  AuthResult.swift
//  TouchIDDemo
//
//  Created by Iva on 19/09/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Gloss

class AuthResult: Decodable {
    
    var header: Header? = nil
    var challenge: String? = nil
    var transaction: [TransactionContent]? = nil
    var policy: Policy? = nil
    
    init() {}
    
    required init?(json: JSON) {
        self.header = "header" <~~ json
        self.challenge = "challenge" <~~ json
        self.transaction = "transaction" <~~ json
        self.policy = "policy" <~~ json
    }
}

class TransactionContent: Decodable {
    var contentType: String? = nil
    var content: String? = nil
    
    required init?(json: JSON) {
        self.content = "content" <~~ json
        self.contentType = "contentType" <~~ json
    }
}
