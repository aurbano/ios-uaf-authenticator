//
//  ValidRegistrations.swift
//  TouchIDDemo
//
//  Created by Iva on 16/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Registrations
import os.log

class ValidRegistrations {
    public static let instance = ValidRegistrations()
    
    var pendingRegistration: String? = ""
    var registrations = [Registrations.Registration]()
    let userDefaults = UserDefaults(suiteName: "group.com.auth.demo")
    let oldUserDefaults = UserDefaults(suiteName: "authApps")
    public let random = "randoooom"

    private init() { }
    
    func addRegistration(registrationToAdd: Registrations.Registration) {
        if (!registrations.contains(registrationToAdd)) {
            registrations += [registrationToAdd]
        }
    }
    
    func deleteRegistration(registrationToDelete: Registrations.Registration) -> Bool {
        for (index, reg) in registrations.enumerated() {
            if reg == registrationToDelete {
                registrations.remove(at: index)
                return true
            }
        }
        return false
    }
    
    func deleteRegistration(atIndex: Int) -> Bool {
        var removed = false
        if (atIndex < items()) {
            registrations.remove(at: atIndex)
            removed = true
        }
        return removed
        }
    
    func reset() {
        registrations.removeAll()
    }
    
    func items() -> Int {
        return registrations.count
    }

    func getRegistrationFrom(registrationId: String) -> Registrations.Registration? {
        for reg in registrations {
            if (reg.registrationId == registrationId) {
                return reg
            }
        }
        return nil
    }
    
    func saveRegistrations() {
        NSKeyedArchiver.setClassName("Registration", for: Registration.self)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: registrations)
        userDefaults?.set(encodedData, forKey: "registrations")
        userDefaults?.synchronize()
    }
}
