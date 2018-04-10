//
//  HttpResponseParser.swift
//  skyscanner-viper
//
//  Created by Ivan Tchernev on 21/03/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation
protocol HttpResponseParserProtocol {
    func parse<T: Codable>(_ data: Data, toType type: T.Type) throws -> T
}
