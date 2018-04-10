//
//  ParserFactory.swift
//  skyscanner-viper
//
//  Created by Ivan Tchernev on 22/03/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation
class ParserFactory {
    static func makeParser(for responseType: ResponseContentType) throws -> HttpResponseParserProtocol {
        switch responseType {
        case .json:
            return JsonParser()
        case .empty:
            throw NetworkingServiceError.unexpectedDataReturned
        }
    }
}
