//
//  StockRoutes.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 2/8/18.
//

import Vapor
import Foundation
import Dispatch

extension Droplet {
    func setupRoutes(stockDataController: StockDataControllerProtocol) throws {
        get("stock/gainers") { req in
            let semaphore = DispatchSemaphore(value: 0)
        
            var modelResponse: Response?
            stockDataController.postDataGainersLosers(.gainers, completion: { (response) in
                switch response {
                case .error:
                    modelResponse = try? ErrorResponse(errorCode: 1, errorMessage: "Unable to parse html").makeResponse(status: .internalServerError)
                case .success(let stocks):
                    modelResponse = try? stocks.makeResponse()
                }
                semaphore.signal()
            })
            
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
            guard let stockResponse = modelResponse else { throw Abort.badRequest }
            return stockResponse
        }
        
        get("stock/losers") { req in
            let semaphore = DispatchSemaphore(value: 0)
            
            var modelResponse: Response?
            stockDataController.postDataGainersLosers(.losers, completion: { (response) in
                switch response {
                case .error:
                    modelResponse = try? ErrorResponse(errorCode: 1, errorMessage: "Unable to parse html").makeResponse(status: .internalServerError)
                case .success(let stocks):
                    modelResponse = try? stocks.makeResponse()
                }
                semaphore.signal()
            })
            
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            
            guard let stockResponse = modelResponse else { throw Abort.badRequest }
            return stockResponse
        }
    }
}
