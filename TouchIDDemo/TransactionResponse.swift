//
//  AuthResponse.swift
//  TouchIDDemo
//
//  Created by Iva on 18/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Gloss
import CryptoSwift
import os.log

class TransactionResponse {
    var header: Header? = nil
    var fcparams: String? = nil
    var assertions: [Assertions]? = nil
    var registrationID: String? = nil
    
    private init() {}
    
    init(header: Header, fcparams: String) {
        self.header = header
        self.fcparams = fcparams
    }
    
    required init?(json: JSON) {
        self.header = "header" <~~ json
        self.fcparams = "fcParams" <~~ json
        self.assertions = "assertions" <~~ json
        self.registrationID = "registrationID" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "header" ~~> self.header,
            "fcParams" ~~> self.fcparams,
            "assertions" ~~> self.assertions,
            "registrationID" ~~> self.registrationID
            ])
    }
    
    func toJSONArray() -> [JSON?] {
        return [toJSON()]
    }

}
