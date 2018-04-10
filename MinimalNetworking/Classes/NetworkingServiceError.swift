//
//  NetworkServiceError.swift
//  MinimalNetworking
//
//  Created by Ivan Tchernev on 10/04/2018.
//

import Foundation
public enum NetworkingServiceError: Error {
    case invalidURL
    case dataEmpty
    case unexpectedDataReturned
    case notImplemented
    case responseInvalid
    case statusCode(Int)
    case testNetworkError
}
