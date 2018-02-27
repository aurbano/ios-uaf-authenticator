//
//  AuthResult.swift
//  TouchIDDemo
//
//  Created by Iva on 19/09/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Gloss

class TransactionRequest: Equatable, Gloss.JSONDecodable {
    
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
    
    static func == (lhs: TransactionRequest, rhs: TransactionRequest) -> Bool {
        return (lhs.challenge == rhs.challenge)
    }

}

class TransactionContent: Gloss.JSONDecodable {
    var contentType: String? = nil
    var content: String? = nil
    var id: Int64?
    
    required init?(json: JSON) {
        self.content = "content" <~~ json
        self.contentType = "contentType" <~~ json
        self.id = "id" <~~ json
    }
}
