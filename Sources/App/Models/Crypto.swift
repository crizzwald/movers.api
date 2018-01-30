//
//  Crypto.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Foundation

public typealias Cryptos = [Crypto]
public struct Crypto: Codable {
    public let number: Int
    public let name: String
    public let marketcap: Float
    public let price: Float
    public let volume: Int
    public let supply: Float
    public let percent: Float
}

extension Crypto {
    public var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
}

extension Array where Element == Cryptos.Element {
    public var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
}
