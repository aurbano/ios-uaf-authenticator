//
//  RegRequest.swift
//  TouchIDDemo
//
//  Created by Iva on 04/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Gloss

class RegRequest: Decodable {
    var header: Header?
    var challenge: String?
    var username: String?
    var policy: Policy?
    
    required init?(json: JSON) {
        self.header = "header" <~~ json
        self.challenge = "challenge" <~~ json
        self.username = "username" <~~ json
        self.policy = "policy" <~~ json
    }
}

class Policy: Decodable {
    var accepted: [AcceptedPolicies]?
    
    required init?(json: JSON) {
        self.accepted = "accepted" <~~ json
    }
}

class AcceptedPolicies: Decodable {
    var aaid: [String]?
    
    required init?(json: JSON) {
        self.aaid = "aaid" <~~ json
    }
}
