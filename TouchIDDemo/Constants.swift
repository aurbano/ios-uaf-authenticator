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
//    static let derCert = "MIIDLjCCAhYCCQCjqhUx7PvwmzANBgkqhkiG9w0BAQsFADBZMQswCQYDVQQGEwJVSzEPMA0GA1UECBMGTG9uZG9uMQ8wDQYDVQQHEwZMb25kb24xCzAJBgNVBAoTAk1TMRswGQYDVQQDExJ3d3cubXMuZXhhbXBsZS5jb20wHhcNMTcwOTA0MTUxNjExWhcNMTgwOTA0MTUxNjExWjBZMQswCQYDVQQGEwJVSzEPMA0GA1UECBMGTG9uZG9uMQ8wDQYDVQQHEwZMb25kb24xCzAJBgNVBAoTAk1TMRswGQYDVQQDExJ3d3cubXMuZXhhbXBsZS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCncT7vcId26aqNMC5cTMxLp+p60sbEmzNYh4RbmxovLDd5TAkWv8M15PLOD6HiV/ZTJM3juVlTuxrreNoHRjkAiTEv0D7PDGYSkoKyvJevnE/P7hr++XpQ8x4m6pQ3Cxw/q5RGSd0aUXKZVLWGC0mVCRSXZR49oppwDisrQC8BczmHQziujPmbGqvjoprlkihgxJChwgJKju1nbgXdKWU0MtEJ98JkmpAne7Y9bDWvBIpvVzdQ54jCjE23j3lY25VaouVUXcgS9273WPfVJVRcc5iA45LSRhxVwTjVqZYIPJMQ9YaQAGtwRCsMYpK5X0BgG0dToGyWu91MREIj58NzAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAGDLdfPFmM+AQ96X8RYyVmiujyfrKkPVkFxAsLrY9uC1jTmsI7+6YaksfWqa2X1usRlwLJlQykVjMjK8+z4249QAd84sFUD+vyKFLRvVYNpypInNjhplwNXXTfV0RZDJ/tij2J75+uwfd/tFbi5SDP8ZcOh/XEa2/kIc4w4qooOiHmbVzFPI8d8GRwmi+SB/gJPNSq4VZUSRsokiSIKRRVvXRHr6R7ifoWfbfMrLCQ2G+uWCXtMgqiikXzwfwUfcyA52AHFP/6AZ8X4fQuoktcADfrU3u2vq0hySieiMAazgpFHB0MdI6XPTAbIxZ3R7UYgOZT5BlxE4TUsIb+4GyDk="
//    static let privateKeyTestTag = "qwertyuiop"
    static let assertionInfo = Array<UInt8>([0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x01])
    static let domain = "http://localhost:8080"
    static let appID = "sometestappid"
    
    struct Environment {
        static let dev = "dev"
        static let uat = "uat"
        static let qa = "qa"
        static let prod = "prod"
    }
}
