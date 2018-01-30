//
//  Encodable+Response.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Foundation
import HTTP

extension Encodable {
    func makeResponse(using encoder: JSONEncoder = JSONEncoder(),
                      status: Status = .ok,
                      contentType: String = "application/json",
                      extraHeaders: [HeaderKey: String] = [:]) throws -> Response {
        let response = Response(status: status)
        response.headers = extraHeaders
        response.headers[.contentType] = contentType
        let data = try encoder.encode(self)
        response.body = Body.data(data.makeBytes())
        return response
    }
}
