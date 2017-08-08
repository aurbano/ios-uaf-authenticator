//
//  RegRequest.swift
//  TouchIDDemo
//
//  Created by Iva on 04/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Gloss

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

class Header: Glossy {
    var upv: Upv? = nil
    var op: String? = nil
    var appId: String? = "http://localhost:8080/v1/public/uaf/facets"
    var serverData: String? = nil
    
    required init?(json: JSON) {
        self.upv = "upv" <~~ json
        self.op = "op" <~~ json
        self.appId = "appID" <~~ json
        self.serverData = "serverData" <~~ json
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
    
    func toJSON() -> JSON? {
        return jsonify([
            "major" ~~> self.major,
            "minor" ~~> self.minor
        ])
    }
}

class Assertions: Glossy {
    var assertionScheme: String?
    var assertion: String?

    init() {
        self.assertion = "AT7uAgM-sQALLgkAQUJDRCNBQkNEDi4HAAABAQEAAAEKLiAA9tBzZC64ecgVQBGSQb5QtEIPC8-Vav4HsHLZDflLaugJLiAAZMCPn92yHv1Ip-iCiBb6i4ADq6ZOv569KFQCvYSJfNgNLggAAQAAAAEAAAAMLkEABJsvEtUsVKh7tmYHhJ2FBm3kHU-OCdWiUYVijgYa81MfkjQ1z6UiHbKP9_nRzIN9anprHqDGcR6q7O20q_yctZAHPjUCBi5AACv8L7YlRMx10gPnszGO6rLFqZFmmRkhtV0TIWuWqYxd1jO0wxam7i5qdEa19u4sfpHFZ9RGI_WHxINkH8FfvAwFLu0BMIIB6TCCAY8CAQEwCQYHKoZIzj0EATB7MQswCQYDVQQGEwJVUzELMAkGA1UECAwCQ0ExCzAJBgNVBAcMAlBBMRAwDgYDVQQKDAdOTkwsSW5jMQ0wCwYDVQQLDAREQU4xMRMwEQYDVQQDDApOTkwsSW5jIENBMRwwGgYJKoZIhvcNAQkBFg1ubmxAZ21haWwuY29tMB4XDTE0MDgyODIxMzU0MFoXDTE3MDUyNDIxMzU0MFowgYYxCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJDQTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzEQMA4GA1UECgwHTk5MLEluYzENMAsGA1UECwwEREFOMTETMBEGA1UEAwwKTk5MLEluYyBDQTEcMBoGCSqGSIb3DQEJARYNbm5sQGdtYWlsLmNvbTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABCGBt3CIjnDowzSiF68C2aErYXnDUsWXOYxqIPim0OWg9FFdUYCa6AgKjn1R99Ek2d803sGKROivnavmdVH-SnEwCQYHKoZIzj0EAQNJADBGAiEAzAQujXnSS9AIAh6lGz6ydypLVTsTnBzqGJ4ypIqy_qUCIQCFsuOEGcRV-o4GHPBph_VMrG3NpYh2GKPjsAim_cSNmQ"
        self.assertionScheme = "UAFV1TLV"
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
}
