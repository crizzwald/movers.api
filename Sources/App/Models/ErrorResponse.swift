//
//  ErrorResponse.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Foundation

struct ErrorResponse: Codable {
    let errorCode: Int
    let errorMessage: String
}
