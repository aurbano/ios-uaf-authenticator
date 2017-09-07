//
//  Assertions.swift
//  TouchIDDemo
//
//  Created by Iva on 11/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Gloss
import CryptoSwift

class Assertions: Glossy {
    var assertionScheme: String?
    var assertion: String?
    var privKeyTag: String?
    var keyID = Array<UInt8>()
    
    init(fcParams: String, keyTag: String, keyID: Array<UInt8>) {
        let assertObj = AuthAssertion(keyTag: keyTag, keyID: keyID)
        self.assertion = assertObj.buildAssertions(fcParams: fcParams)
        self.assertionScheme = Constants.assertionScheme
        
        self.keyID = keyID
        self.privKeyTag = assertObj.getKeyTag()
    }
    
    init(fcParams: String, username: String, environment: String) {
        let assertObj = RegAssertion(username: username, environment: environment)
        self.assertion = assertObj.buildAssertions(fcParams: fcParams)
        self.assertionScheme = Constants.assertionScheme
        
        self.privKeyTag = assertObj.getKeyTag()
        self.keyID = assertObj.getKeyID()

    }
    
    required init?(json: JSON) {
        
        self.assertionScheme = "assertionScheme" <~~ json
        self.assertion = "assertion" <~~ json
        
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "assertionScheme" ~~> self.assertionScheme,
            "assertion" ~~> self.assertion
            ])
    }
    
    func getPrivKeyTag() -> String? {
        return self.privKeyTag
    }
}

class RegAssertion {
    var assertionInfo: String?
    var finalChallenge: String?
    var counter: Bool?
    var pubKey: String?
    var keyID: Array<UInt8>?
    
    private let regAssertionBuilder: RegAssertionBuilder
    
    init(username: String, environment: String) {
        regAssertionBuilder = RegAssertionBuilder(username:username, environment: environment)
    }
    
    func buildAssertions(fcParams: String) -> String? {
        return regAssertionBuilder.getAssertions(fc: fcParams)
    }
    
    func getKeyTag() -> String {
        return regAssertionBuilder.getPrivKeyTag()
    }
    
    func getKeyID() -> Array<UInt8> {
        return regAssertionBuilder.keyID
    }

}

class AuthAssertion {
    var assertionInfo: String?
    var finalChallenge: String?
    var keyID: Array<UInt8>
    var counter: Bool?
    var pubKey: String?
    private let authAssertionBuilder: AuthAssertionBuilder

    init(keyTag: String, keyID: Array<UInt8>) {
        authAssertionBuilder = AuthAssertionBuilder(keyTag: keyTag, keyID: keyID)
        self.keyID = keyID
    }
    
    func buildAssertions(fcParams: String) -> String? {
        return authAssertionBuilder.getAssertions(fcParams: fcParams)
    }
    
    func getKeyTag() -> String {
        return authAssertionBuilder.getPrivKeyTag()
    }
    
}
