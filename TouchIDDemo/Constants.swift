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
    static let derCert = "MIIB-TCCAZ-gAwIBAgIEVTFM0zAJBgcqhkjOPQQBMIGEMQswCQYDVQQGEwJVUzELMAkGA1UECAwCQ0ExETAPBgNVBAcMCFNhbiBKb3NlMRMwEQYDVQQKDAplQmF5LCBJbmMuMQwwCgYDVQQLDANUTlMxEjAQBgNVBAMMCWVCYXksIEluYzEeMBwGCSqGSIb3DQEJARYPbnBlc2ljQGViYXkuY29tMB4XDTE1MDQxNzE4MTEzMVoXDTE1MDQyNzE4MTEzMVowgYQxCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJDQTERMA8GA1UEBwwIU2FuIEpvc2UxEzARBgNVBAoMCmVCYXksIEluYy4xDDAKBgNVBAsMA1ROUzESMBAGA1UEAwwJZUJheSwgSW5jMR4wHAYJKoZIhvcNAQkBFg9ucGVzaWNAZWJheS5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAAQ8hw5lHTUXvZ3SzY9argbOOBD2pn5zAM4mbShwQyCL5bRskTL3HVPWPQxqYVM-3pJtJILYqOWsIMd5Rb_h8D-EMAkGByqGSM49BAEDSQAwRgIhAIpkop_L3fOtm79Q2lKrKxea-KcvA1g6qkzaj42VD2hgAiEArtPpTEADIWz2yrl5XGfJVcfcFmvpMAuMKvuE1J73jp4"
    static let privateKeyTestTag = "com.ms.auth.ebay.testkey789"
    static let assertionInfo = Array<UInt8>([0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x01])
    static let domain = "http://172.20.10.3:8080"
    static let appID = domain + "/v1/public/uaf/facets"
    
    struct Environment {
        static let dev = "dev"
        static let uat = "uat"
        static let qa = "qa"
        static let prod = "prod"
    }
}
