//
//  PendingTransactions.swift
//  TouchIDDemo
//
//  Created by Iva on 18/09/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import MapKit
import Gloss

class PendingTransactions {
    private static var transactions = [Transaction]()
    private init() {}
    
    static func addTransaction(t: Transaction) {
        transactions.append(t)
    }
    
    static func removeTransaction(t: Transaction) -> Bool {
        if let index = transactions.index(where: { $0 == t}) {
            transactions.remove(at: index)
            return true
        }
        return false
    }
    
    static func removeTransaction(atIndex: Int) -> Bool {
        if (atIndex < transactions.count) {
            transactions.remove(at: atIndex)
            return true
        }
        return false
    }
    
    static func getTransactions() -> [Transaction] {
        return transactions
    }
    
    static func getTransaction(atIndex: Int) -> Transaction {
        return transactions[atIndex]
    }
    
    static func items() -> Int {
        return transactions.count
    }

}

class Transaction: Equatable, Gloss.Decodable {
    var currency: Currency?
    var value: Int?
    var date: String?
    var company: String?
    var location: CLLocationCoordinate2D?
    
    init(value: Int, currency: Currency, date: String, company: String, location: [Double]) {
        self.value = value
        self.date = date
        self.company = company
        self.currency = currency
        self.location = CLLocationCoordinate2D(latitude: location[0], longitude: location[1])
    }
    
    required init?(json: JSON) {
        self.currency = "currency" <~~ json
        self.value = "value" <~~ json
        self.date = "date" <~~ json
        self.company = "company" <~~ json
        self.location = "location" <~~ json
    }

    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return (lhs.value == rhs.value &&
                lhs.company == rhs.company &&
                lhs.date == rhs.date &&
                lhs.location!.latitude == rhs.location!.latitude &&
                lhs.location!.longitude == rhs.location!.longitude )
    }
}

