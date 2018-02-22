//
//  URLRequestFactory.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/28/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

import Foundation

final public class URLRequestFactory {

    // MARK: - Properties

    public var accessToken: String?
    public var baseURL: URL


    // MARK: - Initializers

    public init(accessToken: String? = nil, baseURL: URL = Environment.defaultEnvironment().baseURL) {
        self.accessToken = accessToken
        self.baseURL = baseURL
    }


    // MARK: - Public

    public func buildURL(_ baseURL: URL? = nil, path: String) -> URL? {
        let standardizedBaseURL = (baseURL ?? self.baseURL).appendingPathComponent("")
        return URL(string: path, relativeTo: standardizedBaseURL)
    }

    public func buildRequest(_ method: PayPalHereClient.Method, _ path: String, parameters: JSONDictionary? = nil, headers: JSONDictionary? = nil, baseURL: URL? = nil) -> URLRequest? {

        guard let URL = buildURL(baseURL, path: path) else {
            return nil
        }

        var request = URLRequest(url: URL)
        request.httpMethod = method.rawValue

        if let parameters = parameters, !parameters.isEmpty {
            switch method {
            case .GET, .DELETE, .HEAD:
                if var components = URLComponents(url: URL, resolvingAgainstBaseURL: true) {
                    let queryItems = parameters
                        .sorted { (lhs, rhs) in
                            return lhs.0 < rhs.0
                        }
                        .flatMap { (key, value) -> (String, String)? in
                            if let key = escape(key), let value = escape(value) {
                                return (key, value)
                            }

                            return nil
                        }.map(URLQueryItem.init)
                    components.queryItems = queryItems
                    request.url = components.url
                }
            default:
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                } catch {
                    return nil
                }
            }
        }

        if let accessToken = accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        if let headers = headers as? [String: String] {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        return request
    }

    public func buildMulitpartRequest(_ method: PayPalHereClient.Method, _ path: String, bodyParts: [BodyPart], headers: JSONDictionary? = nil, baseURL: URL? = nil) -> URLRequest? {
        guard let URL = buildURL(baseURL, path: path), method != .GET || method != .HEAD else {
            return nil
        }

        var request = URLRequest(url: URL)
        request.httpMethod = method.rawValue

        let boundary = "tikomnev.omnev.moc"

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let body = FormData(bodyParts: bodyParts, boundaryValue: boundary)

        request.httpBody = body.data
        request.setValue("\(body.contentLength)", forHTTPHeaderField: "Content-Length")

        if let accessToken = accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        if let headers = headers as? [String: String] {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        return request
    }


    // MARK - Private

    fileprivate func escape<T: Any>(_ anything: T) -> String? {
        if let date = anything as? Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            return formatter.string(from: date)
          }

        return String(describing: anything)
    }
}
