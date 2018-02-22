//
//  SessionConfigurationFactory.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/28/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

import Foundation

final public class SessionConfigurationFactory {

    // MARK: - Public

    public static func defaultConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHTTPHeaders
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        return configuration
    }

    public static func backgroundConfiguration(_ identifier: String) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.background(withIdentifier: identifier)
        configuration.httpAdditionalHeaders = SessionConfigurationFactory.defaultHTTPHeaders
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        configuration.sharedContainerIdentifier = "PayPal Here"
        return configuration
    }


    // MARK: - Private

    fileprivate static let defaultHTTPHeaders: [String: Any] = {
        let acceptEncoding = "gzip;q=1.0,compress;q=0.5"

        let acceptLanguage: String = {
            var components = [String]()

            for (index, languageCode) in Locale.preferredLanguages.enumerated() {
                let q = 1.0 - (Double(index) * 0.1)
                components.append("\(languageCode);q=\(q)")

                if q <= 0.5 {
                    break
                }
            }

            return components.joined(separator: ",")
        }()

        return [
            "Accept": "application/json; charset=utf-8",
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": "PayPalHere",
            "device-id": "DeviceId" // Device.fingerprint
        ]
    }()
}

