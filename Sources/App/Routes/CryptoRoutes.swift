//
//  CryptoRoutes.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Vapor
import Foundation
import Dispatch

extension Droplet {
    func setupRoutes(cryptoDataController: CryptoDataControllerProtocol) throws {
        let baseResource = "crypto"
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
        
        get("\(baseResource)/all") { req in
            //let semaphore = DispatchSemaphore(value: 0)
            
            var modelResponse: Response?
            cryptoDataController.getDataGainersLosers(completion: { (response) in
                switch response {
                case .error:
                    modelResponse = try? ErrorResponse(errorCode: 1, errorMessage: "Unable to parse html").makeResponse(status: .internalServerError)
                case .success(let cryptos):
                    modelResponse = try? cryptos.makeResponse()
                }
                //semaphore.signal()
            })
            
             //_ = semaphore.wait(timeout: DispatchTime.distantFuture)
            
            guard let cryptoResponse = modelResponse else { throw Abort.badRequest }
            return cryptoResponse
        }
    }
}
