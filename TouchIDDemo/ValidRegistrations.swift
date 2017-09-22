//
//  ValidRegistrations.swift
//  TouchIDDemo
//
//  Created by Iva on 16/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation

class ValidRegistrations {
    static var registrations = [Registration]()
    
    private init() { }
        
    static func addRegistration(registrationToAdd: Registration) {
        if (!registrations.contains(registrationToAdd)) {
            registrations += [registrationToAdd]
        }
    }
    
    static func deleteRegistration(registrationToDelete: Registration) -> Bool {
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
    
    static func getRegistrationFrom(registrationId: String) -> Registration? {
        for reg in registrations {
            if (reg.registrationId == registrationId) {
                return reg
            }
        }
        return nil
    }
}
