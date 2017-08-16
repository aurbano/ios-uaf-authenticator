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
    let environment: String
    let username: String
    
    init(appID: String, keyTag: String, url: String, env: String, username: String) {
        self.appID = appID
        self.keyTag = keyTag
        self.url = url
        self.environment = env
        self.username = username
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(appID, forKey: PropertyKey.appID)
        aCoder.encode(keyTag, forKey: PropertyKey.keyTag)
        aCoder.encode(url, forKey: PropertyKey.url)
        aCoder.encode(environment, forKey: PropertyKey.env)
        aCoder.encode(username, forKey: PropertyKey.username)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        func decodeObject(key: String, aDecoder: NSCoder) -> String {
            guard let property = aDecoder.decodeObject(forKey: key) as? String else {
                print(ErrorString.Encoding.unableToDecode + key)
                return String()
            }
            return property
        }

        
        let appID = decodeObject(key: PropertyKey.appID, aDecoder: aDecoder)
        let keyTag = decodeObject(key: PropertyKey.keyTag, aDecoder: aDecoder)
        let url = decodeObject(key: PropertyKey.url, aDecoder: aDecoder)
        let environment = decodeObject(key: PropertyKey.env, aDecoder: aDecoder)
        let username = decodeObject(key: PropertyKey.username, aDecoder: aDecoder)
        
        self.init(appID: appID, keyTag: keyTag, url: url, env: environment, username: username)
    }
    
}
