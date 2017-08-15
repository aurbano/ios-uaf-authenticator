//
//  Tags.swift
//  TouchIDDemo
//
//  Created by Iva on 14/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation

enum Tags: Int {
    case UAF_CMD_STATUS_ERR_UNKNOWN = 0x01
    case TAG_UAFV1_REG_ASSERTION = 0x3E01
    case TAG_UAFV1_AUTH_ASSERTION = 0x3E02
    case TAG_UAFV1_KRD = 0x3E03
    case TAG_UAFV1_SIGNED_DATA = 0x3E04
    case TAG_ATTESTATION_CERT = 0x2E05
    case TAG_SIGNATURE = 0x2E06
    case TAG_ATTESTATION_BASIC_FULL = 0x3E07
    case TAG_ATTESTATION_BASIC_SURROGATE = 0x3E08
    case TAG_KEYID = 0x2E09
    case TAG_FINAL_CHALLENGE = 0x2E0A
    case TAG_AAID = 0x2E0B
    case TAG_PUB_KEY = 0x2E0C
    case TAG_COUNTERS = 0x2E0D
    case TAG_ASSERTION_INFO = 0x2E0E
    case TAG_AUTHENTICATOR_NONCE = 0x2E0F
    case TAG_TRANSACTION_CONTENT_HASH = 0x2E10
    case TAG_EXTENSION = 0x3E11
    case TAG_EXTENSION_NON_CRITICAL = 0x3E12
    case TAG_EXTENSION_ID = 0x2E13
    case TAG_EXTENSION_DATA = 0x2E14
    
}
