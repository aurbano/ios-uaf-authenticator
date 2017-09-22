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
    
    static func removeTransaction(t: Transaction) {
        if let index = transactions.index(where: { $0 == t}) {
            transactions.remove(at: index)
        }
    }
    
    static func removeTransaction(atIndex: Int) {
        if (atIndex < transactions.count) {
            transactions.remove(at: atIndex)
        }
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
    
    static func reset() {
        transactions = [Transaction]()
    }

}

class Transaction: Equatable, Gloss.Decodable {
    var currency: Currency?
    var value: Int?
    var date: String?
    var company: String?
    var location: CLLocationCoordinate2D?
    var registrationId: String?
    var txId: Int64?
    
    init(value: Int,
         currency: Currency,
         date: String,
         company: String,
         location: [Double],
         registrationId: String,
         txId: Int64) {
        
        self.registrationId = registrationId
        self.value = value
        self.date = date
        self.company = company
        self.currency = currency
        self.location = CLLocationCoordinate2D(latitude: location[0], longitude: location[1])
        self.txId = txId
    }
    
    init(data: String, registrationId: String, txId: Int64) {
        self.registrationId = registrationId
        self.company = data
        self.date = "29/09/17"
        self.currency = Currency.gbp
        self.value = 1000000
        self.location = CLLocationCoordinate2D(latitude: 51.504901, longitude: -0.024186199999999998)
        self.txId = txId
    }
    
    required init?(json: JSON) {
        self.currency = "currency" <~~ json
        self.value = "value" <~~ json
        self.date = "date" <~~ json
        self.company = "company" <~~ json
        self.location = "location" <~~ json
    }

    func addRegIdTxId(registrationId: String, txId: Int64) {
        self.registrationId = registrationId
        self.txId = txId
    }
   
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return (lhs.value == rhs.value &&
                lhs.company == rhs.company &&
                lhs.date == rhs.date &&
                lhs.location!.latitude == rhs.location!.latitude &&
                lhs.location!.longitude == rhs.location!.longitude )
    }
}

