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
    static var switchedTxChallenge = String()
    private static var transactions = [Transaction]()
    private init() {}
    
    static func addTransaction(t: Transaction) {
        transactions.append(t)
        print("added")
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
    
    static func getTransactionIndexBy(challenge: String) -> Int {
        for (index, tx) in transactions.enumerated() {
            if (tx.challenge == challenge) {
                return index
            }
        }
        return -1
    }
    
    static func clear() {
        transactions.removeAll()
    }

}

class Transaction: Equatable, Gloss.Decodable {
    var currency: Currency?
    var value: Int?
    var date: String?
    var contents: String?
    var location: CLLocationCoordinate2D?
    var registrationId: String?
    var challenge: String?
    
    init(value: Int,
         currency: Currency,
         date: String,
         contents: String,
         location: [Double],
         registrationId: String) {
        
        self.registrationId = registrationId
        self.value = value
        self.date = date
        self.contents = contents
        self.currency = currency
        self.location = CLLocationCoordinate2D(latitude: location[0], longitude: location[1])
        self.challenge = String()
    }
    
    init(data: String, registrationId: String, challenge: String) {
        self.registrationId = registrationId
        self.contents = data
        self.date = "29/09/17"
        self.currency = Currency.gbp
        self.value = 1000000
        self.location = CLLocationCoordinate2D(latitude: 51.504901, longitude: -0.024186199999999998)
        self.challenge = challenge
    }
    
    required init?(json: JSON) {
        self.currency = "currency" <~~ json
        self.value = "value" <~~ json
        self.date = "date" <~~ json
        self.contents = "contents" <~~ json
        self.location = "location" <~~ json
        self.challenge = "challenge" <~~ json
    }

    func addRegIdTxId(registrationId: String, txId: Int64) {
        self.registrationId = registrationId
    }
   
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return (lhs.value == rhs.value &&
                lhs.contents == rhs.contents &&
                lhs.date == rhs.date &&
                lhs.location!.latitude == rhs.location!.latitude &&
                lhs.location!.longitude == rhs.location!.longitude )
    }
}

