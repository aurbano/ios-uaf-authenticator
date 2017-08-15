//
//  MemStore.swift
//  TouchIDDemo
//
//  Created by Iva on 14/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation

class Registration: NSObject, NSCoding {
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("registrations")

    
    let appID: String
    let keyTag: String
    let url: String
    
    init(appID: String, keyTag: String, url: String) {
        self.appID = appID
        self.keyTag = keyTag
        self.url = url
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(appID, forKey: PropertyKey.appID)
        aCoder.encode(keyTag, forKey: PropertyKey.keyTag)
        aCoder.encode(url, forKey: PropertyKey.url)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let appID = aDecoder.decodeObject(forKey: PropertyKey.appID) as? String else {
            print("Unable to decode app id")
            return nil
        }
        guard let keyTag = aDecoder.decodeObject(forKey: PropertyKey.keyTag) as? String else {
            print("Unable to decode key tag")
            return nil
        }

        guard let url = aDecoder.decodeObject(forKey: PropertyKey.url) as? String else {
            print("Unable to decode url")
            return nil
        }
        
        self.init(appID: appID, keyTag: keyTag, url: url)
    }
}

struct PropertyKey {
    static let keyTag = "keyTag"
    static let appID = "appId"
    static let url = "url"
}
