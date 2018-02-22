//
//  PayPalHereErrorType.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/28/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//
 

/// The ValidationErrorType protocol is adopted by an object that can provide a Error stuct
/// Every errors in PayPalHere should conform to PayPalHereErrorType
public protocol PayPalHereErrorType: Swift.Error {
    var error: Error { get }
}
