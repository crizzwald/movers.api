//
//  Stock.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 2/8/18.
//

import Foundation

public typealias Stocks = [Stock]
public struct Stock: Codable {
    public let symbol: String
    public let exchange: String
    public let open: Float
    public let high: Float
    public let low: Float
    public let close: Float
    public let volume: Int
    public let percent: Float
}

extension Stock {
    public var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
}

extension Array where Element == Stocks.Element {
    public var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
}
