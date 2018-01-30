//
//  CryptoDataController.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Foundation
import SwiftSoup

public protocol CryptoDataControllerProtocol {
    func getDataGainersLosers(completion: @escaping CryptoDataControllerCompletion<Cryptos>)
}

public enum CryptoDataControllerResponse<T: Codable> {
    case success(T)
    case error(Int?, Error?)
}

public typealias CryptoDataControllerCompletion<T: Codable> = (_ response: CryptoDataControllerResponse<T>) -> ()

public class CryptoDataController: CryptoDataControllerProtocol {
    private enum Constants {
        enum Keys {
            static let currencies: String = "currencies"
            static let currencyName: String = "currency-name-container"
            static let tbody: String = "tbody"
            static let tr: String = "tr"
            static let td: String = "td"
            static let a: String = "a"
            static let span: String = "span"
        }
    }
    
    private enum RowTypes: Int {
        case number = 0
        case name = 1
        case marketcap = 2
        case price = 3
        case volume = 4
        case supply = 5
        case percent = 6
    }
    
    private let cryptoDataManager: CryptoDataManagerProtocol
    
    public init(cryptoDataManager: CryptoDataManagerProtocol) {
        self.cryptoDataManager = cryptoDataManager
    }
    
    public func getDataGainersLosers(completion: @escaping (CryptoDataControllerResponse<Cryptos>) -> ()) {
        cryptoDataManager.getDataGainersLosers { (response) in
            switch response {
            case .success(let html):
                guard let cryptos = self.parseRaw(html) else {
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
    private func parseRaw(_ html: String) -> Cryptos? {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            guard let table: Element = try doc.select("#\(Constants.Keys.currencies)").first(),
                let tbody: Element = try table.select("\(Constants.Keys.tbody)").first()
            else { return nil }
            
            let trows: Elements = try tbody.select("\(Constants.Keys.tr)")
            var cryptos: [Crypto] = []
            for trow: Element in trows.array() {
                let tds: Elements = try trow.select("\(Constants.Keys.td)")
                
                var number: String?
                var name: String?
                var marketcap: String?
                var price: String?
                var volume: String?
                var supply: String?
                var percent: String?
                
                for (index, td) in tds.array().enumerated() {
                    guard let rowType = RowTypes(rawValue: index) else { break }
                    switch rowType {
                    case .number:
                        number = try? td.html()
                    case .name:
                        guard let anchor: Element = try td.select(".\(Constants.Keys.currencyName)").first() else { break }
                        name = try? anchor.html()
                    case .marketcap:
                        marketcap = try? td.html()
                    case .price:
                        guard let anchor: Element = try td.select("\(Constants.Keys.a)").first() else { break }
                        price = try? anchor.html()
                    case .volume:
                        guard let anchor: Element = try td.select("\(Constants.Keys.a)").first() else { break }
                        volume = try? anchor.html()
                    case .supply:
                        guard let anchor: Element = try td.select("\(Constants.Keys.a)").first(), let span: Element = try anchor.select("\(Constants.Keys.span)").first() else { break }
                        supply = try? span.html()
                    case .percent:
                        percent = try? td.html()
                    }
                }
                
                guard let rawNumber = number?.trim(), let cryptoNumber = Int(rawNumber),
                    let cryptoName = name?.trim(),
                    let rawMarketcap = marketcap?.trim().replaceRawCharacters(), let cryptoMarketcap = Float(rawMarketcap),
                    let rawPrice = price?.trim().replaceRawCharacters(), let cryptoPrice = Float(rawPrice),
                    let rawVolume = volume?.trim().replaceRawCharacters(), let cryptoVolume = Int(rawVolume),
                    let rawSupply = supply?.trim().replaceRawCharacters(), let cryptoSupply = Float(rawSupply),
                    let rawPercent = percent?.trim().replaceRawCharacters(), let cryptoPercent = Float(rawPercent)
                    else { break }
                
                let crypto = Crypto(number: cryptoNumber, name: cryptoName, marketcap: cryptoMarketcap, price: cryptoPrice, volume: cryptoVolume, supply: cryptoSupply, percent: cryptoPercent)
                cryptos.append(crypto)
            }
            
            return cryptos
        } catch {
            return nil
        }
    }
}