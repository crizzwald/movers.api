//
//  StockDataController.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 2/8/18.
//

import Foundation
import SwiftSoup

public protocol StockDataControllerProtocol {
    func postDataGainersLosers(_ type: StockType, completion: @escaping StockDataControllerCompletion<Stocks>)
}

public enum StockDataControllerResponse<T: Codable> {
    case success(T)
    case error(Int?, Error?)
}

public typealias StockDataControllerCompletion<T: Codable> = (_ response: StockDataControllerResponse<T>) -> ()

public class StockDataController: StockDataControllerProtocol {
    private enum Constants {
        enum Keys {
            
        }
    }
    
    private enum RowTypes: Int {
        case analysis = 0
        case symbol = 1
        case exchange = 2
        case open = 3
        case high = 4
        case low = 5
        case close = 6
        case volume = 7
        case percent = 8
    }
    
    private let stockDataManager: StockDataManagerProtocol
    
    public init(stockDataManager: StockDataManagerProtocol) {
        self.stockDataManager = stockDataManager
    }
    
    public func postDataGainersLosers(_ type: StockType, completion: @escaping (StockDataControllerResponse<Stocks>) -> ()) {
        stockDataManager.postDataGainersLosers(type) { (response) in
            switch response {
            case .success(let html):
                guard let stocks = self.parseRaw(html) else {
                    completion(.error(nil, ModelError.cannotParseData))
                    break
                }
                completion(.success(stocks))
            case .error(let int, let error):
                completion(.error(int, error))
            }
        }
    }
    
    // MARK: Parser
    private func parseRaw(_ html: String) -> Stocks? {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            guard let table: Element = try doc.select("#content > div > table").first(),
                let tbody: Element = try table.select("tbody").first()
                else { return nil }

            let trows: Elements = try tbody.select("tr")
            var stocks: [Stock] = []
            for trow: Element in trows.array() {
                // check for the header row, we don't need them so break
                let ths : Elements = try trow.select("th")
                if ths.array().count > 0 {
                    continue
                }
                
                let tds: Elements = try trow.select("td")

                var symbol: String?
                var exchange: String?
                var open: String?
                var high: String?
                var low: String?
                var close: String?
                var volume: String?
                var percent: String?

                for (index, td) in tds.array().enumerated() {
                    guard let rowType = RowTypes(rawValue: index) else { break }
                    switch rowType {
                    case .analysis:
                        break
                    case .symbol:
                        symbol = try? td.html()
                    case .exchange:
                        exchange = try? td.html()
                    case .open:
                        open = try? td.html()
                    case .high:
                        high = try? td.html()
                    case .low:
                        low = try? td.html()
                    case .close:
                        close = try? td.html()
                    case .volume:
                        volume = try? td.html()
                    case .percent:
                        guard let font: Element = try td.select("font").first() else { break }
                        percent = try? font.html()
                    }
                }

                guard let stockSymbol = symbol,
                    let stockExchange = exchange,
                    let rawOpen = open, let stockOpen = Float(rawOpen),
                    let rawHigh = high, let stockHigh = Float(rawHigh),
                    let rawLow = low, let stockLow = Float(rawLow),
                    let rawClose = close, let stockClose = Float(rawClose),
                    let rawVolume = volume, let stockVolume = Int(rawVolume),
                    let rawPercent = percent?.trim().replaceRawCharacters(), let stockPercent = Float(rawPercent)
                else { break }
                
                let stock = Stock(symbol: stockSymbol, exchange: stockExchange, open: stockOpen, high: stockHigh, low: stockLow, close: stockClose, volume: stockVolume, percent: stockPercent)
                stocks.append(stock)
            }

            return stocks
        } catch {
            return nil
        }
    }
}
