//
//  CryptoRoutes.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Vapor

extension Droplet {
    func setupRoutes(cryptoDataController: CryptoDataControllerProtocol) throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
    }
}
