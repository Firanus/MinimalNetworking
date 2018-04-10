//
//  TestUtilities.swift
//  MinimalNetworking_Example
//
//  Created by Ivan Tchernev on 10/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import MinimalNetworking

class TestUtilities {
    static func extractError<T>(from networkResponse: NetworkResponse<T>, ofType errorType: NetworkingServiceError? = nil) -> Error? {
        switch networkResponse {
        case .failure(let networkError):
            if let expectedCustomError = errorType, let returnedCustomError = networkError as? NetworkingServiceError {
                if expectedCustomError == returnedCustomError {
                    return returnedCustomError
                } else {
                    return nil
                }
            } else {
                return networkError
            }
        default:
            return nil
        }
    }
}

extension NetworkingServiceError: Equatable {
    public static func ==(lhs: NetworkingServiceError, rhs: NetworkingServiceError) -> Bool {
        return lhs.isEqual(error: rhs)
    }
    
    func isEqual(error: NetworkingServiceError)->Bool {
        switch self {
        case .statusCode(let code1):
            if case .statusCode(let code2) = error, code1 == code2 { return true }
        case .dataEmpty:
            if case .dataEmpty = error { return true }
        case .invalidURL:
            if case .invalidURL = error { return true }
        case .unexpectedDataReturned:
            if case .unexpectedDataReturned = error { return true }
        case .notImplemented:
            if case .notImplemented = error { return true }
        case .responseInvalid:
            if case .responseInvalid = error { return true }
        case .testNetworkError:
            if case .testNetworkError = error { return true }
        }
        
        return false
    }
}
