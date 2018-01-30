//
//  Session.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Foundation

public protocol SessionProtocol {
    init(configuration: URLSessionConfiguration)
    func task(with request: RequestProtocol, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionDataTaskProtocol?
}

public protocol SessionDataTaskProtocol {
    func resume()
}

extension URLSession: SessionProtocol {
    public func task(with request: RequestProtocol, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionDataTaskProtocol? {
        guard let request = request as? URLRequest else {
            return nil
        }
        
        return dataTask(with: request, completionHandler: completionHandler)
    }
}

extension URLSessionDataTask: SessionDataTaskProtocol {}
