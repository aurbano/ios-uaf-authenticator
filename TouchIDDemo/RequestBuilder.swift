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
    private var request : URLRequest
    
    init(url: String, method: String) {
        self.url = URL(string: url)!
        self.headers = [String() : String()]
        self.request = URLRequest(url: self.url)
        self.request.httpMethod = method
    }
    
    func addHeaders(headers: [String : String]) {
        for (value, field) in headers {
            self.request.addValue(value, forHTTPHeaderField: field)
        }
    }
    
    func addBody(body: Data) {
        if (self.request.httpMethod == "POST") {
            self.request.httpBody = body
        }
    }
    
    func getRequest() -> URLRequest {
        return self.request
    }
}
