//
//  BasicError.swift
//  ThreeRingControl
//
//  Created by Tilahun, Yoseph on 2/22/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

// Use this if you want to display the server error without handling any specific case.
/// Warning: use responsibly.
public enum BasicError: ValidationErrorType {

    case generic(error: Error)
    case unknown

    public init?(dictionary: JSONDictionary, headers: JSONDictionary?) {
        guard let error = Error(dictionary: dictionary) else {
            self = .unknown
            return
        }

        self = BasicError.generic(error: error)
    }

    public var error: Error {
        switch self {
        case .generic(let error): return error
        case .unknown: return Error()
        }
    }
}

