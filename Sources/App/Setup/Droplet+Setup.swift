@_exported import Vapor

import Foundation

extension Droplet {
    public func setup() throws {
        let cryptoHttpClient = HttpClient(url: BaseURLs.coinMarketCap, accessToken: nil)
        let cryptoDataManager = CryptoDataManager(httpClient: cryptoHttpClient)
        let cryptoDataController = CryptoDataController(cryptoDataManager: cryptoDataManager)
        
        try setupRoutes(cryptoDataController: cryptoDataController)
    }
}
