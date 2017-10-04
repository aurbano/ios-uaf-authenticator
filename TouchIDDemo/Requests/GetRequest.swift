//
//  RegRequest.swift
//  TouchIDDemo
//
//  Created by Iva on 04/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Gloss

class GetRequest: Gloss.Decodable {
    var header: Header?
    var challenge: String?
    var username: String?
    var policy: Policy?
    
    init() { }

    
    required init?(json: JSON) {
        self.header = "header" <~~ json
        self.challenge = "challenge" <~~ json
        self.username = "username" <~~ json
        self.policy = "policy" <~~ json
    }
}

class Policy: Gloss.Decodable {
    var accepted: [AcceptedPolicies]?
    
    required init?(json: JSON) {
        self.accepted = "accepted" <~~ json
    }
}

class AcceptedPolicies: Gloss.Decodable {
    var aaid: [String]?
    var vendorID: [String]?
    var keyIDs: [String]?
    var userVerification: Int64?
    var keyProtection: Int?
    var matcherProtection: Int?
    var attachmentHint: Int64?
    var tcDisplay: Int?
    var authenticationAlgorithms: [Int]?
    var assertionSchemes: [String]?
    var attestationTypes: [Int]?
    var authenticatorVersion: Int?
    var exts: [String]?
    
    required init?(json: JSON) {
        self.aaid = "aaid" <~~ json
        self.vendorID = "vendorID" <~~ json
        self.keyIDs = "keyIDs" <~~ json
        self.userVerification = "userVerification" <~~ json
        self.keyProtection = "keyProtection" <~~ json
        self.matcherProtection = "matcherProtection" <~~ json
        self.attachmentHint = "attachmentHint" <~~ json
        self.tcDisplay = "tcDisplay" <~~ json
        self.authenticatorVersion = "authenticatorVersion" <~~ json
        self.authenticationAlgorithms = "authenticationAlgorithms" <~~ json
        self.assertionSchemes = "assertionSchemes" <~~ json
        self.attestationTypes = "attestationTypes" <~~ json
        self.exts = "exts" <~~ json
    }
}
