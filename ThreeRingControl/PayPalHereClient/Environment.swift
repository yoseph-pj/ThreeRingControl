//
//  Environment.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 12/29/17.
//  Copyright © 2017 Tilahun, Yoseph. All rights reserved.
//
import UIKit

public enum Environment {
    case production
    case beta
    case hosted
    case local
    case qa
    case custom(baseUrl: String, internalUrl: String, webUrl: String)


    // MARK: - Private

    public static let environmentProcessInfoKey = "API_ENVIRONMENT"
    public static let customBaseURLProcessInfoKey = "API_BASE_URL"
    public static let customInternalBaseURLProcessInfoKey = "API_INTERNAL_BASE_URL"
    public static let customWebViewBaseURLProcessInfoKey = "API_WEB_VIEW_BASE_URL"

    public enum Keys: String {
        case production = "PRODUCTION"
        case beta = "BETA"
        case hosted = "HOSTED"
        case local = "LOCAL"
        case qa = "QA"
        case custom = "CUSTOM"
    }

    // MARK: - Public

    public static func defaultEnvironment() -> Environment {
        let environmentVariables = ProcessInfo.processInfo.environment
       // guard let environment = .production //Environment(dictionary: environmentVariables) else { return .production }
        return .qa
    }


    public var baseURL: URL {
        switch self {
        case .production: return URL(string: "https://api.venmo.com/v1")!
        case .beta: return URL(string: "https://developer-api-staging.venmo.com/v1")!
        case .hosted: return URL(string: "https://api-pt.dev.venmo.biz/v1")!
        case .local: return URL(string: "https://api.dev.venmo.com/v1")!
        case .qa: return URL(string: "https://api.qa.venmo.com/v1")!
        case .custom(let baseURLString, _, _): return URL(string: baseURLString)!
        }
    }

    public var internalBaseURL: URL {
        switch self {
        case .production: return URL(string: "https://venmo.com/api/v5")!
        case .beta: return URL(string: "https://betaweb.venmo.com/api/v5")!
        case .hosted: return URL(string: "https://pt.dev.venmo.biz/api/v5")!
        case .local: return URL(string: "https://dev.venmo.com/api/v5")!
        case .qa: return URL(string: "https://qa.venmo.com/api/v5")!
        case .custom(_, let internalBaseURLString, _): return URL(string: internalBaseURLString)!
        }
    }

    public var webViewBaseURL: URL {
        switch self {
        case .production: return URL(string: "https://venmo.com/webviews")!
        case .beta: return URL(string: "https://betaweb.venmo.com/webviews")!
        case .hosted: return URL(string: "https://pt.dev.venmo.biz/webviews")!
        case .local: return URL(string: "https://dev.venmo.com/webviews")!
        case .qa: return URL(string: "https://qa.venmo.com/webviews")!
        case .custom(_, _, let webViewBaseURLString): return URL(string: webViewBaseURLString)!
        }
    }

    public var key: String {
        switch self {
        case .production: return Keys.production.rawValue
        case .beta: return Keys.beta.rawValue
        case .hosted: return Keys.hosted.rawValue
        case .local: return Keys.local.rawValue
        case .qa: return Keys.qa.rawValue
        case .custom: return Keys.custom.rawValue
        }
    }
}

extension Environment: DictionarySerializable, DictionaryDeserializable {
    public init?(dictionary: JSONDictionary) {
        guard let environmentString = dictionary[Environment.environmentProcessInfoKey] as? String else { return nil }

        switch environmentString {
        case Keys.production.rawValue:
            self = .production
        case Keys.beta.rawValue:
            self = .beta
        case Keys.local.rawValue:
            self = .local
        case Keys.hosted.rawValue:
            self = .hosted
        case Keys.qa.rawValue:
            self = .qa
        case Keys.custom.rawValue:
            guard let baseURLString = dictionary[Environment.customBaseURLProcessInfoKey] as? String,
                let internalBaseURLString = dictionary[Environment.customInternalBaseURLProcessInfoKey] as? String,
                let customWebViewBaseURLString = dictionary[Environment.customWebViewBaseURLProcessInfoKey] as? String
                else { return nil }
            self = .custom(baseUrl: baseURLString, internalUrl: internalBaseURLString, webUrl: customWebViewBaseURLString)
        default:
            return nil
        }
    }

    public var dictionary: JSONDictionary {
        switch self {
        case .production:
            return [Environment.environmentProcessInfoKey: Keys.production.rawValue]
        case .beta:
            return [Environment.environmentProcessInfoKey: Keys.beta.rawValue]
        case .local:
            return [Environment.environmentProcessInfoKey: Keys.local.rawValue]
        case .hosted:
            return [Environment.environmentProcessInfoKey: Keys.hosted.rawValue]
        case .qa:
            return [Environment.environmentProcessInfoKey: Keys.qa.rawValue]
        case .custom(let baseUrl, let internalUrl, let webUrl):
            return [
                Environment.environmentProcessInfoKey: Keys.custom.rawValue,
                Environment.customBaseURLProcessInfoKey: baseUrl,
                Environment.customInternalBaseURLProcessInfoKey: internalUrl,
                Environment.customWebViewBaseURLProcessInfoKey: webUrl
            ]
        }
    }
}

extension Environment: Equatable {}
public func == (lhs: Environment, rhs: Environment) -> Bool {
    switch (lhs, rhs) {
    case
    (.production, .production),
    (.beta, .beta),
    (.hosted, .hosted),
    (.local, .local),
    (.qa, .qa):
        return true
    case (.custom(let lhsBase, let lhsInternal, let lhsWebView), .custom(let rhsBase, let rhsInternal, let rhsWebView)):
        return lhsBase == rhsBase && lhsInternal == rhsInternal && lhsWebView == rhsWebView
    default: return false
    }
}

