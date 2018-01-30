//
//  HttpClient.swift
//  movers.apiPackageDescription
//
//  Created by Christopher Crown on 1/30/18.
//

import Foundation

/** The typealias for the HTTP completion handler.
 
 - Parameter response: An instance of `HTTPReponse`
 */

public typealias HTTPCompletion = (_ response: HTTPResponse) -> ()

/**
 The HTTP error
 
 - cannotParseData: The error state when json in the response is in a format we don’t expect
 - statusCode: An error with a status code and custom message as the associated value
 */
public enum HTTPError: LocalizedError {
    case cannotParseResponse
    case statusCode(Int, message: String)
    
    public var errorDescription: String? {
        if case .statusCode(_, let message) = self {
            return message
        }
        
        return nil
    }
}

/**
 HTTP response
 
 - success: The request had a successful response. Dictionary associated value
 - error: The request had an error response. Optional error code and error associated value
 */
public enum HTTPResponse {
    case success(Data)
    case error(Int?, Error?)
}

public protocol HttpClientProtocol {
    init(url: URL, accessToken: String?)
    
    func get(_ route: String, queryItems: [URLQueryItem]?, completion: @escaping HTTPCompletion)
}

fileprivate enum Constants {
    enum HttpVerbs {
        static let get = "GET"
    }
    
    enum Headers {
        static let applicationJson = "text/html; charset=utf-8"
        static let contentType = "Content-Type"
        
        static let authorization = "Authorization"
        static let bearer = "Bearer"
    }
    
    enum StatusCodes {
        static let success = 200
    }
}

public class HttpClient<SessionType: SessionProtocol, RequestType: RequestProtocol>: HttpClientProtocol {
    let session: SessionType = SessionType(configuration: URLSessionConfiguration.default)
    let url: URL
    
    /// The access token used to sign requests. If non-nil, it will be included in the request header
    public var accessToken: String?
    
    /**
     Initializes a new instance of RestHttpClient
     
     - Parameters:
     - url: The server url where all requests will be sent
     - accessToken: An optional access token used to sign requests.
     */
    public required init(url: URL, accessToken: String?) {
        self.url = url
        self.accessToken = accessToken
    }
    
    /**
     Send a GET request to the URL/route specified
     
     - Parameters:
     - route: The route that the request should be sent to
     - completion: The completion block which will be called when the request is done
     */
    public func get(_ route: String, queryItems: [URLQueryItem]? = nil, completion: @escaping HTTPCompletion) {
        // Build the url
        var urlComponents = URLComponents()
        urlComponents.scheme = url.scheme
        urlComponents.host = url.host
        urlComponents.path = route
        urlComponents.queryItems = queryItems
        
        guard let requestUrl = urlComponents.url else {
            completion(.error(nil, nil))
            return
        }
        
        var request = RequestType(url: requestUrl)
        request.httpMethod = Constants.HttpVerbs.get
        request.addValue(Constants.Headers.applicationJson, forHTTPHeaderField: Constants.Headers.contentType)
        
        if let accessToken = accessToken {
            request.addValue("\(Constants.Headers.bearer) \(accessToken)", forHTTPHeaderField: Constants.Headers.authorization)
        }
        
        let task = session.task(with: request) { (data, response, error) in
            // Make sure we don't have a connectivity error
            if let error = error {
                completion(.error(nil, error))
                return
            }
            
            // Make sure we have a 200 status code
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode != Constants.StatusCodes.success {
                    completion(.error(nil, HTTPError.statusCode(statusCode, message: "dataTaskWithRequest HTTP status code \(statusCode)")))
                    return
                }
            }
            
            // Do something with data
            guard let data = data else {
                completion(.error(nil, HTTPError.cannotParseResponse))
                return
            }
            
            completion(.success(data))
        }
        
        task?.resume()
    }
}
