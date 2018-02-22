//
//  ValidationErrorType.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/28/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

/// The ValidationErrorType protocol is adopted by an object that handles validation errors sent by the server
public protocol ValidationErrorType: PayPalHereErrorType {
    init?(dictionary: JSONDictionary, headers: JSONDictionary?)
}

