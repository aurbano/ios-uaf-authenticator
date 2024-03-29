//
//  RegRequest.swift
//  TouchIDDemo
//
//  Created by Iva on 04/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Gloss
import CryptoSwift
import os.log

class RegResponse: Glossy {
    var header: Header? = nil
    var fcparams: String? = nil
    var assertions: [Assertions]? = nil
    
    init(header: Header, fcparams: String) {
        self.header = header
        self.fcparams = fcparams
    }
    
    required init?(json: JSON) {
        self.header = "header" <~~ json
        self.fcparams = "fcParams" <~~ json
        self.assertions = "assertions" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "header" ~~> self.header,
            "fcParams" ~~> self.fcparams,
            "assertions" ~~> self.assertions,
        ])
    }
    
    func toJSONArray() -> [JSON?] {
        return [toJSON()]
    }
}



