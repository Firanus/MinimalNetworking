//
//  HTTPServiceProtocol.swift
//  skyscanner-viper
//
//  Created by Ivan Tchernev on 16/03/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation

public enum NetworkResponse<T> {
    case success(T, HTTPURLResponse)
    case failure(Error)
}
