//
//  String+Replace.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Foundation

extension String {
    func replaceRawCharacters() -> String? {
        return self.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "%", with: "")
    }
}
