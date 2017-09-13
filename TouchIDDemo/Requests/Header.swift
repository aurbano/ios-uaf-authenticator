//
//  Header.swift
//  TouchIDDemo
//
//  Created by Iva on 14/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Gloss

class Header: Glossy {
    var upv: Upv? = nil
    var op: String? = nil
    var appId: String? = Constants.appID
    var serverData: String? = nil
    
    required init?(json: JSON) {
        self.upv = "upv" <~~ json
        self.op = "op" <~~ json
        self.appId = "appID" <~~ json
        self.serverData = "serverData" <~~ json
    }
    
    init(serverData: String) {
        self.upv = Upv()
        self.op = "Reg"
        self.appId = Constants.appID
        self.serverData = serverData
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "upv" ~~> self.upv,
            "op" ~~> self.op,
            "appId" ~~> self.appId,
            "serverData" ~~> self.serverData
            ])
    }
    
}

class Upv: Glossy {
    var major: Int? = 1
    var minor: Int? = 0
    
    required init?(json: JSON) {
        self.major = "major" <~~ json
        self.minor = "minor" <~~ json
    }
    
    init() {}
    
    func toJSON() -> JSON? {
        return jsonify([
            "major" ~~> self.major,
            "minor" ~~> self.minor
            ])
    }
}
