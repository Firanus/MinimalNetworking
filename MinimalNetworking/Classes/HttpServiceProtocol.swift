//
//  HTTPServiceProtocol.swift
//  skyscanner-viper
//
//  Created by Ivan Tchernev on 16/03/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation
protocol HttpServiceProtocol: class {
    func post<T: Codable>(url urlString: String,
                          body: POSTBodyEncodable,
                          responseContentType: ResponseContentType,
                          additionalHeaders: [String:String],
                          completion: @escaping (NetworkResponse<T?>) -> Void) -> URLSessionDataTaskProtocol?
    
    // pass in valid URL, content type, headers and a completion block -> get back data task, completion block should get called with a success result of our type.
    func get<T: Codable>(url urlString: String,
                         responseContentType: ResponseContentType,
                         additionalHeaders: [String:String],
                         completion: @escaping (NetworkResponse<T?>) -> Void) -> URLSessionDataTaskProtocol?
}

enum NetworkResponse<T> {
    case success(T, HTTPURLResponse)
    case failure(Error)
}

enum ResponseContentType {
    case json
    case empty
}

enum NetworkingServiceError: Error {
    case invalidURL
    case dataEmpty
    case unexpectedDataReturned
    case notImplemented
    case responseInvalid
    case statusCode(Int)
    case testNetworkError
}
