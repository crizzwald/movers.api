//
//  StockDataManager.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 2/8/18.
//

import Foundation

public enum StockType: String {
    case gainers = "up"
    case losers = "down"
}

public protocol StockDataManagerProtocol {
    func postDataGainersLosers(_ type: StockType, completion: @escaping StockDataManagerCompletion)
}

public enum StockDataManagerResponse {
    case success(String)
    case error(Int?, Error?)
}

public typealias StockDataManagerCompletion = (_ response: StockDataManagerResponse) -> ()

public class StockDataManager: StockDataManagerProtocol {
    enum Constants {
        enum Endpoints {
            static let all = "/penny-stocks/"
        }
    }
    
    private let httpClient: HttpClientProtocol
    
    public init(httpClient: HttpClientProtocol) {
        self.httpClient = httpClient
    }
    
    public func postDataGainersLosers(_ type: StockType, completion: @escaping StockDataManagerCompletion) {
        let queryItems = [URLQueryItem(name: "price", value: "1"), URLQueryItem(name: "volume", value: "0"), URLQueryItem(name: "updown", value: type.rawValue)]
        httpClient.post(Constants.Endpoints.all, queryItems: queryItems) { (response) in
            switch response {
            case .success(let data):
                guard let content = String(data: data, encoding: .ascii) else {
                    completion(.error(nil, ModelError.cannotParseData))
                    break
                }
                completion(.success(content))
                break
            case .error(let int, let error):
                completion(.error(int, error))
                break
            }
        }
    }
}
