//
//  CryptoDataManager.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Foundation


public protocol CryptoDataManagerProtocol {
    func getDataGainersLosers(completion: @escaping CryptoDataManagerCompletion)
}

public enum CryptoDataManagerResponse {
    case success(String)
    case error(Int?, Error?)
}

public typealias CryptoDataManagerCompletion = (_ response: CryptoDataManagerResponse) -> ()

public class CryptoDataManager: CryptoDataManagerProtocol {
    enum Constants {
        enum Endpoints {
            static let all = "/all/views/all"
        }
    }
    
    private let httpClient: HttpClientProtocol
    
    public init(httpClient: HttpClientProtocol) {
        self.httpClient = httpClient
    }
    
    public func getDataGainersLosers(completion: @escaping CryptoDataManagerCompletion) {
        httpClient.get(Constants.Endpoints.all, queryItems: nil) { (response) in
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

