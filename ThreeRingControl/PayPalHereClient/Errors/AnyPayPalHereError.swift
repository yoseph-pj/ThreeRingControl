//
//  AnyPayPalHereError.swift
//  ThreeRingControl
//
//  Created by Tilahun, Yoseph on 2/22/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

public struct AnyPayPalHereError: PayPalHereErrorType {
    fileprivate let underlyingError: PayPalHereErrorType

    public init<E: PayPalHereErrorType>(underlyingError: E) {
        self.underlyingError = underlyingError
    }

    public var error: Error {
        return underlyingError.error
    }
}

