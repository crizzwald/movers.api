//
//  Request.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Foundation

public protocol RequestProtocol {
    var httpMethod: String? { get set }
    var httpBody: Data? { get set }
    
    init(url: URL)
    mutating func addValue(_ value: String, forHTTPHeaderField field: String)
}

extension URLRequest: RequestProtocol {
    public init(url: URL) {
        self.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
    }
}
