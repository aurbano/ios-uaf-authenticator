//
//  RegOutcome.swift
//  TouchIDDemo
//
//  Created by Iva on 07/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Gloss
import CryptoSwift

class RegOutcome: Gloss.JSONDecodable {
    var authenticatorVersion: String?
    var publicKey: String?
    var signCounter: String?
    var attestCert: String?
    var attestDataToSign: String?
    var attestSignature: String?
    var attestVerifiedStatus: AttestationStatus!
    var authenticator: Authenticator?
    var deviceID: String?
    var status: Status!
    var tcDisplayPNGCharacteristics: String?
    var timestamp: Int64?
    var userID: String?
    var username: String?
    var registrationId: String!
    
    required init?(json: JSON) {
        self.authenticatorVersion = "AuthenticatorVersion" <~~ json
        self.publicKey = "PublicKey" <~~ json
        self.signCounter = "SignCounter" <~~ json
        self.attestCert = "attestCert" <~~ json
        self.attestDataToSign = "attestDataToSign" <~~ json
        self.attestSignature = "attestSignature" <~~ json
        self.attestVerifiedStatus = "attestVerifiedStatus" <~~ json
        self.authenticator = "authenticator" <~~ json
        self.deviceID = "deviceId" <~~ json
        self.status = "status" <~~ json
        self.tcDisplayPNGCharacteristics = "tcDisplayPNGCharacteristics" <~~ json
        self.timestamp = "timeStamp" <~~ json
        self.userID = "userId" <~~ json
        self.username = "username" <~~ json
        self.registrationId = "registrationId" <~~ json
    }
}

enum AttestationStatus: String {
    case VALID = "VALID"
    case FAILED_VALIDATION_ATTEMPT = "FAILED_VALIDATION_ATTEMPT"
    case NOT_VERIFIED = "NOT_VERIFIED"
}

enum Status: String {
    case SUCCESS = "SUCCESS"
    case ASSERTIONS_CHECK_FAILED = "ASSERTIONS_CHECK_FAILED"
}

class Authenticator: Gloss.JSONDecodable {
    var aaid: String?
    var keyID: String?
    var deviceID: String?
    var status: String?
    var username: String?
    
    required init?(json: JSON) {
        self.aaid = "AAID" <~~ json
        self.keyID = "KeyID" <~~ json
        self.deviceID = "deviceId" <~~ json
        self.status = "status" <~~ json
        self.username = "username" <~~ json

    }
}
