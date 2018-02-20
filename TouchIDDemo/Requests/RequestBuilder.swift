//
//  RequestBuilder.swift
//  TouchIDDemo
//
//  Created by Iva on 15/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation

class RequestBuilder {
    
    private let url: URL
    private let headers: [String : String]
    private var request: URLRequest
    private var timeout: Double
    
    init(url: String, method: String) {
        self.url = URL(string: url)!
        self.headers = [String() : String()]
        self.request = URLRequest(url: self.url)
        self.request.httpMethod = method
        self.timeout = 10
    }
    
    init(url: String, method: String, timeout: Double) {
        self.url = URL(string: url)!
        self.headers = [String() : String()]
        self.request = URLRequest(url: self.url)
        self.request.httpMethod = method
        self.timeout = timeout
    }


    
    func addHeaders(headers: [String : String]) {
        for (value, field) in headers {
            self.request.addValue(value, forHTTPHeaderField: field)
        }
    }
    
    func addBody(body: Data) {
        if (self.request.httpMethod == "PUT" || self.request.httpMethod == "POST") {
            self.request.httpBody = body
        }
    }
    
    func addBody(body: [[String: Any]]) {
        let json = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)        
        self.addBody(body: json!)

    }
    
    func getRequest() -> URLRequest {
        self.request.timeoutInterval  = self.timeout
        return self.request
    }
}
