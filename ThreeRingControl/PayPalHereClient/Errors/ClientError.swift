//
//  ClientError.swift
//  ThreeRingControl
//
//  Created by Tilahun, Yoseph on 2/22/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

import Foundation

/// All errors that do not have to do with response validation
public enum ClientError: PayPalHereErrorType, Equatable {
    /// No Internet
    case notConnectedToInternet

    /// The request timed out
    case requestTimedOut

    /// The request was canceled
    case canceled

    /// The request could not be formed
    case invalidRequest

    /// The response from the server could not be parsed
    case invalidResponse

    /// 400 status code
    case errorResponse

    /// Error code is an OAuthTokenErrorCode
    case invalidToken(OAuthTokenErrorCode)

    /// 500+ status code
    case internalError


    // MARK: - VenmoErrorType

    public var error: Error {
        var message = localize("CLIENT_ERROR_MESSAGE")

        switch self {
        case .notConnectedToInternet: message = localize("CLIENT_UNREACHABLE_ERROR_MESSAGE")
        case .requestTimedOut: message = localize("CLIENT_TIMED_OUT_ERROR_MESSAGE")
        default: break
        }

        return Error(title: localize("CLIENT_ERROR_TITLE"), message: message)
    }

    // MARK: - OAuth token error codes

    public enum OAuthTokenErrorCode: Int {
        case deletedToken = 259
        case missingScope = 260
        case invalidToken = 261
        case revokedToken = 262
        case expiredToken = 265
        case missingToken = 267
    }


    // MARK: - Initilizer

    public init(error: NSError) {
        #if os(iOS) || os(OSX)
            if CFNetworkErrors(rawValue: Int32(error.code)) == CFNetworkErrors.cfurlErrorNotConnectedToInternet {
                self = .notConnectedToInternet
                return
            } else if CFNetworkErrors(rawValue: Int32(error.code)) == CFNetworkErrors.cfurlErrorTimedOut {
                self = .requestTimedOut
                return
            }

            if CFNetworkErrors(rawValue: Int32(error.code)) == CFNetworkErrors.cfurlErrorCancelled {
                self = .canceled
                return
            }
        #endif

        self = .invalidResponse
    }
}

public func == (lhs: ClientError, rhs: ClientError) -> Bool {
    switch (lhs, rhs) {
    case (.notConnectedToInternet, .notConnectedToInternet): return true
    case (.requestTimedOut, .requestTimedOut): return true
    case (.canceled, .canceled): return true
    case (.invalidRequest, .invalidRequest): return true
    case (.invalidResponse, .invalidResponse): return true
    case (.errorResponse, .errorResponse): return true
    case (.invalidToken(let lhsErrorCode), .invalidToken(let rhsErrorCode)): return lhsErrorCode == rhsErrorCode
    case (.internalError, .internalError): return true
    default:
        return false
    }
}

