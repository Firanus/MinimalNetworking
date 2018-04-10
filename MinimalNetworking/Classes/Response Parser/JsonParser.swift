//
//  JsonParser.swift
//  skyscanner-viper
//
//  Created by Ivan Tchernev on 22/03/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation
class JsonParser: HttpResponseParserProtocol {
    func parse<T: Codable>(_ inputData: Data, toType type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(type, from: inputData)
        } catch {
            throw error
        }
    }
}
