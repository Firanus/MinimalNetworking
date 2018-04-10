//
//  POSTBodyEncodable.swift
//  skyscanner-viper
//
//  Created by Ivan Tchernev on 03/04/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation
protocol POSTBodyEncodable {
    var asFormUrlEncoded: String { get }
}
