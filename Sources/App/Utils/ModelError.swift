//
//  ModelError.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Foundation

/**
 The Model error
 - cannotParseData: The error state when json in the response is in a format we don’t expect
 */

public enum ModelError: LocalizedError {
    case cannotParseData
}
