//
//  URLSessionMock.swift
//  MinimalNetworking_Example
//
//  Created by Ivan Tchernev on 10/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import MinimalNetworking

class URLSessionMock: URLSession {
    var nextDataTask = URLSessionDataTaskMock()
    
    var nextData: Data? = nil
    var nextResponse: URLResponse? = HTTPURLResponse(url: URL(string: "https://and.digital")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    var nextError: Error? = nil
    
    private(set) var lastRequest: URLRequest? = nil
    
    public override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        lastRequest = request
        completionHandler(nextData, nextResponse, nextError)
        return nextDataTask
    }
}
