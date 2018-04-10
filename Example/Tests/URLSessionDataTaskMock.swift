//
//  URLSessionDataTaskMock.swift
//  MinimalNetworking_Example
//
//  Created by Ivan Tchernev on 10/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import MinimalNetworking

class URLSessionDataTaskMock: URLSessionDataTask {
    
    private(set) var resumeCalled = false
    
    public override func resume() { resumeCalled = true }
}
