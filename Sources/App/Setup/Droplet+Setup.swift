@_exported import Vapor

import Foundation

extension Droplet {
    public func setup() throws {
        let cryptoHttpClient = HttpClient(url: BaseURLs.coinMarketCap, accessToken: nil)
        let cryptoDataManager = CryptoDataManager(httpClient: cryptoHttpClient)
        let cryptoDataController = CryptoDataController(cryptoDataManager: cryptoDataManager)
        
        let stockHttpClient = HttpClient(url: BaseURLs.stocksUnderOne, accessToken: nil)
        let stockDataManager = StockDataManager(httpClient: stockHttpClient)
        let stockDataController = StockDataController(stockDataManager: stockDataManager)
        
        try setupRoutes(cryptoDataController: cryptoDataController)
        try setupRoutes(stockDataController: stockDataController)
    }
}
