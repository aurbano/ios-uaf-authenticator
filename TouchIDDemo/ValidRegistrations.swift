//
//  ValidRegistrations.swift
//  TouchIDDemo
//
//  Created by Iva on 16/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Registrations

class ValidRegistrations {
    static var pendingRegistration: String? = ""
    static var registrations = [Registrations.Registration]()
    static let userDefaults = UserDefaults(suiteName: "group.com.ms.auth.iva")
    static let oldUserDefaults = UserDefaults(suiteName: "authApps")

    private init() { }
        
    static func addRegistration(registrationToAdd: Registrations.Registration) {
        if (!registrations.contains(registrationToAdd)) {
            registrations += [registrationToAdd]
        }
    }
    
    static func deleteRegistration(registrationToDelete: Registrations.Registration) -> Bool {
        for (index, reg) in registrations.enumerated() {
            if reg == registrationToDelete {
                registrations.remove(at: index)
                return true
            }
        }
        return false
    }
    
    static func deleteRegistration(atIndex: Int) -> Bool {
        var removed = false
        if (atIndex < items()) {
            registrations.remove(at: atIndex)
            removed = true
        }
        return removed
        }
    
    static func reset() {
        registrations.removeAll()
    }
    
    static func items() -> Int {
        return registrations.count
    }

    static func getRegistrationFrom(registrationId: String) -> Registrations.Registration? {
        for reg in registrations {
            if (reg.registrationId == registrationId) {
                return reg
            }
        }
        return nil
    }
    
    static func saveRegistrations() {
        NSKeyedArchiver.setClassName("Registration", for: Registration.self)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: ValidRegistrations.registrations)
        ValidRegistrations.userDefaults?.set(encodedData, forKey: "registrations")
        ValidRegistrations.userDefaults?.synchronize()
    }
}
