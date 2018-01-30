//
//  BaseUrls.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Foundation

public struct BaseURLs {
    public static let coinMarketCap: URL = {
        return URL(string: "https://coinmarketcap.com")!
    }()
}
