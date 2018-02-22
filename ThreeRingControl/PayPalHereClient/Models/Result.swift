//
//  Result.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/28/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

import Foundation

public enum Result<T, U: PayPalHereErrorType> {
    /// The request succeeded
    case success(T)

    /// The request failed due to validation errors
    case validationFailure(U)

    /// The client failed to make the request or the server failed to handle the request
    case clientFailure(ClientError)
}

extension Result {
    func map<V>(_ f: ((T) -> V)) -> Result<V, U> {
        switch self {
        case .success(let t): return .success(f(t))
        case .clientFailure(let error): return .clientFailure(error)
        case .validationFailure(let error): return .validationFailure(error)
        }
    }

    func mapError<E: PayPalHereErrorType>(_ f: ((U) -> E)) -> Result<T, E> {
        switch self {
        case .success(let t): return .success(t)
        case .clientFailure(let error): return .clientFailure(error)
        case .validationFailure(let error): return .validationFailure(f(error))
        }
    }
}
