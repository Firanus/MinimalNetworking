//
//  URLSessionDataTaskProtocol.swift
//  skyscanner-viper
//
//  Created by Ivan Tchernev on 26/03/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation
protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
