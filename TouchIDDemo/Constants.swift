//
//  Constants.swift
//  TouchIDDemo
//
//  Created by Iva on 16/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation

struct Constants {
    static let aaid = "EBA0#0001"
    static let assertionScheme = "UAFV1TLV"
    static let assertionInfo = Array<UInt8>([0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x01])
    static let domain = "https://uaf-test-service.herokuapp.com"
    static let appID = "http://169.254.226.97:8080/v1/public/uaf/facets"
    
    struct Environment {
        static let dev = "dev"
        static let uat = "uat"
        static let qa = "qa"
        static let prod = "prod"
    }
    struct TabBarControllersIndex {
        static let home = 0
        static let transactions = 1
        static let registrations = 2
    }
    
    struct URL {
        static let transactions = "/v1/public/authResponse/"
        static let completeReg = "/v1/public/regResponse"
    }
}
