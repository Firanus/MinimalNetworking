//
//  POSTBodyEncodableMock.swift
//  MinimalNetworking_Tests
//
//  Created by Ivan Tchernev on 10/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import MinimalNetworking

class POSTBodyEncodableMock: POSTBodyEncodable {
    var nextBody: String = ""
    var asFormUrlEncoded: String {
        return nextBody
    }
}
