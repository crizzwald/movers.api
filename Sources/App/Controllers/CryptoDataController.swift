//
//  CryptoDataController.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Foundation

public protocol CryptoDataControllerProtocol {
    func getDataGainersLosers(completion: @escaping CryptoDataControllerCompletion<Cryptos>)
}

public enum CryptoDataControllerResponse<T: Codable> {
    case success(T)
    case error(Int?, Error?)
}

public typealias CryptoDataControllerCompletion<T: Codable> = (_ response: CryptoDataControllerResponse<T>) -> ()

public class CryptoDataController: CryptoDataControllerProtocol {
    
    private let cryptoDataManager: CryptoDataManagerProtocol
    
    public init(cryptoDataManager: CryptoDataManagerProtocol) {
        self.cryptoDataManager = cryptoDataManager
    }
    
    public func getDataGainersLosers(completion: @escaping (CryptoDataControllerResponse<Cryptos>) -> ()) {
        cryptoDataManager.getDataGainersLosers { (response) in
            switch response {
            case .success(let string):
                guard let cryptos = self.parseRawGainersLosers(string) else {
                    completion(.error(nil, ModelError.cannotParseData))
                    break
                }
                completion(.success(cryptos))
            case .error(let int, let error):
                completion(.error(int, error))
            }
        }
    }
    
    // MARK: Parser
    private func parseRawGainersLosers(_ raw: String) -> Cryptos? {
        return nil
    }
}
