//
//  PayPalHereClient.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/28/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

import Foundation

@objc open class PayPalHereClient: NSObject {

    // MARK: - Types

    public enum Method: String, CustomStringConvertible {
        case OPTIONS = "OPTIONS"
        case GET = "GET"
        case HEAD = "HEAD"
        case POST = "POST"
        case PUT = "PUT"
        case PATCH = "PATCH"
        case DELETE = "DELETE"
        case TRACE = "TRACE"
        case CONNECT = "CONNECT"

        public var description: String {
            return rawValue
        }
    }


    // MARK: - Properties

    open let URLSession: URLSession
    open let environment: Environment
    open var accessToken: String? {
        didSet {
            requestFactory.accessToken = accessToken
        }
    }

    fileprivate let callbackQueue: DispatchQueue

    open static let tokenDidInvalidate = Foundation.Notification.Name(rawValue: "VenmoKit.ClientTokenDidInvalidateNotification")
    open static let OAuthTokenErrorCodeNotificationKey = "VenmoKit.ClientOAuthTokenErrorCodeNotificationKey"

    open var baseURL: URL {
        return environment.baseURL
    }

    open var internalBaseURL: URL {
        return environment.internalBaseURL
    }

    
    let requestFactory: URLRequestFactory

    internal static let defaultSession: URLSession = {
        return Foundation.URLSession(configuration: SessionConfigurationFactory.defaultConfiguration())
    }()

    /*   static let defaultSession: URLSession = {
     return Foundation.URLSession(configuration: SessionConfigurationFactory.defaultConfiguration())
     }()
     */
    // MARK: - Initializers

    public init(accessToken: String? = nil, URLSession: URLSession = defaultSession, environment: Environment = Environment.defaultEnvironment(), requestFactory: URLRequestFactory? = nil, callbackQueue: DispatchQueue = DispatchQueue.main) {
        self.accessToken = accessToken
        self.URLSession = URLSession
        self.environment = environment
        self.callbackQueue = callbackQueue
        self.requestFactory = requestFactory ?? URLRequestFactory(accessToken: accessToken, baseURL: environment.baseURL)
        super.init()
    }


    // MARK: - Public

    open func performRequest<Input, Output, OutputError: ValidationErrorType>(_ method: Method, path: String, parameters: JSONDictionary? = nil, headers: JSONDictionary? = nil, baseURL: URL? = nil, completion: @escaping (Result<Output, OutputError>) -> Void, success: @escaping ((Input) -> Output?)) -> Task? {

        guard let URLRequest = requestFactory.buildRequest(method, path, parameters: parameters, headers: headers, baseURL: baseURL) else {
            // Failed to create a request
            performOnCallbackQueue(completion)(.clientFailure(ClientError.invalidRequest))
            return nil
        }

        return performRequest(URLRequest, completion: completion, success: success)
    }

    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    open func performRequest<Input, Output, OutputError: ValidationErrorType>(_ URLRequest: URLRequest, completion: @escaping (Result<Output, OutputError>) -> Void, success: @escaping ((Input) -> Output?)) -> Task? {
        // swiftlint:enable function_body_length
        // swiftlint:enable cyclomatic_complexity

        let completion = performOnCallbackQueue(completion)

        PayPalHereClient.incrementConnectionCount()

        let task = URLSession.dataTask(with: URLRequest, completionHandler: { data, response, error in
            PayPalHereClient.didPerform(URLRequest, data: data, response: response as? HTTPURLResponse, error: error as NSError?)
            PayPalHereClient.decrementConnectionCount()

            var result: Result<Output, OutputError>
            defer { completion(result) }

            // Validation response
            guard let response = response as? HTTPURLResponse else {
                if let error = error {
                    result = .clientFailure(ClientError(error: error as NSError))
                } else {
                    result = .clientFailure(.invalidResponse)
                }
                return
            }

            // Content-Length is not always returned by the server currently.
            // This guarantees `contentLength` is initialized to a non-zero value.
            let contentLength: Int
            if let contentLengthString = response.allHeaderFields["Content-Length"] as? String, let length = Int(contentLengthString) {
                contentLength = length
            } else {
                contentLength = 1
            }

            let status = response.statusCode

            let successRange = 200..<300
            let redirectRange = 300..<400
            let clientErrorRange = 400..<500
            let serverErrorRange = 500..<600

            switch status {
            case successRange:
                if Input.self == Void.self {
                    result = .success(() as! Output) // swiftlint:disable:this force_cast
                    return
                }

                // Check content type if there is content
                guard let contentType = response.allHeaderFields["Content-Type"] as? String else {
                    result = .clientFailure(.invalidResponse)
                    return
                }

                let isJSON = contentType.range(of: "application/json") != nil

                // Invalid Content-Type
                if !isJSON && contentLength != 0 {
                    // Expected JSON
                    result = .clientFailure(.invalidResponse)
                    return
                }

                // Try to parse data
                guard let data = data else {
                    result = .clientFailure(.invalidResponse)
                    return
                }

                PayPalHereClient.willAttemptDeserialization(of: data)

                defer {
                    let result = result
                        .map({ $0 as Any })
                        .mapError(AnyPayPalHereError.init)
                    PayPalHereClient.didAttemptDeserialization(of: data, result: result)
                }

                guard let parsedData = PayPalHereClient.parseData(data), contentLength > 0 else {
                    result = .clientFailure(.invalidResponse)
                    return
                }



             //   let data: Data // received from a network request, for example
              //  let json = try? JSONSerialization.jsonObject(with: data, options: [])
              // var subdic: Dictionary = Dictionary()
              //  var subdicExt = [String: Any]()
               /* if var dictionary = json as? [String: Any] {
                    if let number = dictionary["providers"] as? [String: Any] {
                        // access individual value in dictionary
                    }

                    for (key, value) in dictionary {
                          print(key)
                          print(value)
                        if key == "providers" {
                            if var subdic  =  value as? [String: Any] {
                                if let idx = subdic.index(forKey: "providerId") {
                                    subdic.remove(at: idx)
                                }
                              subdicExt = subdic
                            }


                        }
                        // access all key / value pairs in dictionary
                    }

                    for (key, value) in subdicExt {
                        print(key)
                        print(value)
                        // access all key / value pairs in dictionary
                    }


                    if let idx = dictionary.index(forKey: "providerId") {
                        dictionary.remove(at: idx)
                        // ["baz": 3, "foo": 1]
                    }
                     print(dictionary)
                    for (key, value) in dictionary {
                        print(key)
                        print(value)
                        // access all key / value pairs in dictionary
                    }


                } */

              //  var jsonResult = data as Dictionary<String, String>

               // let str =  parsedData as? String ?? ""

               // var dictionary1 = self.convertToDictionary(from: str )
               // print(dictionary1) // prints: ["City": "Paris"]

               // if let idx = dictionary1.index(forKey: "providerId") {
               //     dictionary1.remove(at: idx)
               //     print(dictionary1) // ["baz": 3, "foo": 1]
               // }
                if  let dictx = parsedData as? JSONDictionary {
                    if let number = dictx["coupons"] as? Input {
                       let valuex = success(number)
                  }
                }

                
                // Success
                if let dict = parsedData as? JSONDictionary, let response = PaginatedResponse(dictionary: dict), let input = response as? Input, let value = success(input) {
                    result = .success(value)
                }
                else if let dict = parsedData as? JSONDictionary, let input = dict["coupons"] as? Input, let value = success(input) {
                    // for v5, better to do this here than everywhere, hopefully we will remove that shortly
                    result = .success(value)
                } else if let input = parsedData as? Input, let value = success(input) {
                    result = .success(value)
                } else {
                    // Failed to unpack object
                    result = .clientFailure(.invalidResponse)
                }
                return
            case redirectRange:
                // Redirects are currently unsupported by VenmoKit.
                result = .clientFailure(.invalidResponse)
                return
            case clientErrorRange:
                // Try to parse data
                guard let data = data, let parsedData = PayPalHereClient.parseData(data), contentLength > 0 else {
                    result = .clientFailure(.invalidResponse)
                    return
                }

                if let dictionary = parsedData as? JSONDictionary {
                    // Succeed to parse error response
                    if let errorCode = Error(dictionary: dictionary)?.code, let oauthErrorCode = ClientError.OAuthTokenErrorCode(rawValue: errorCode) {
                        // OAuth token error
                        result = .clientFailure(.invalidToken(oauthErrorCode))
                        return
                    } else if let validationError = OutputError(dictionary: dictionary, headers: response.allHeaderFields as? JSONDictionary) {
                        // Matched with the validation error
                        result = .validationFailure(validationError)
                        return
                    }
                }

                // Failed to parse error response
                result = .clientFailure(.errorResponse)
                return
            case serverErrorRange:
                result = .clientFailure(.internalError)
                return
            default:
                result = .clientFailure(.invalidResponse)
                return
            }
        })

        // Start task
        PayPalHereClient.willPerform(task)
        task.resume()
        return Task(task: task, callbackQueue: callbackQueue)
    }


    // MARK: - Internal
  //YTYT To be removed
   internal  func convertToDictionary(from text: String) -> [String: String] {
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any? = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String] ?? [:]
    }

    internal func performOnCallbackQueue<T, U>(_ completion: @escaping (Result<T, U>) -> Void) -> ((Result<T, U>) -> Void) {
        let callbackQueue = self.callbackQueue

        return { result in
            switch result {
            case .clientFailure(let error):
                PayPalHereClient.errorDidOccur(error)
                self.processClientFailureError(error)
            case .validationFailure(let error):
                PayPalHereClient.errorDidOccur(error)
            case .success: break
            }

            callbackQueue.async { completion(result) }
        }
    }


    // MARK: - Private

    fileprivate static func parseData(_ data: Data) -> Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print("$$$$$$$$$$$$$$")
            print(json)
            print("$$$$$$$$$$$$$$")
            return json
        } catch {
            return nil
        }
    }

    fileprivate func processClientFailureError(_ error: ClientError) {
        switch error {
        case .invalidToken(let errorCode):
            let userInfo = [PayPalHereClient.OAuthTokenErrorCodeNotificationKey: errorCode.rawValue]
            postNotification(named: PayPalHereClient.tokenDidInvalidate, userInfo: userInfo)
        default:
            return
        }
    }

    fileprivate func postNotification(named notificationName: Foundation.Notification.Name, userInfo: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: PayPalHereClient.tokenDidInvalidate, object: self, userInfo: userInfo)
        }
    }

    internal static var networkingLoggers: [NetworkingLoggable] = []
    internal static var deserializationLoggers: [DeserializationLoggable] = []
    internal static var errorLoggers: [ErrorLoggable] = []
}

extension PayPalHereClient {
    public static func registerNetworkingLogger(_ networkingLogger: NetworkingLoggable) {
        networkingLoggers.append(networkingLogger)
    }

    public static func registerDeserializationLogger(_ deserializationLogger: DeserializationLoggable) {
        deserializationLoggers.append(deserializationLogger)
    }

    public static func registerErrorLogger(_ errorLogger: ErrorLoggable) {
        errorLoggers.append(errorLogger)
    }

    fileprivate static func willPerform(_ task: URLSessionDataTask) {
        for logger in networkingLoggers {
            logger.willPerform(task)
        }
    }

    fileprivate static func didPerform(_ request: URLRequest, data: Data?, response: HTTPURLResponse?, error: NSError?) {
        for logger in networkingLoggers {
            logger.didPerform(request, data: data, response: response, error: error)
        }
    }

    fileprivate static func willAttemptDeserialization(of data: Data) {
        for logger in deserializationLoggers {
            logger.willAttemptDeserialization(of: data)
        }
    }

    fileprivate static func didAttemptDeserialization(of data: Data, result: Result<Any, AnyPayPalHereError>) {
        for logger in deserializationLoggers {
            logger.didAttemptDeserialization(of: data, result: result)
        }
    }

    fileprivate static func errorDidOccur<E: PayPalHereErrorType>(_ error: E) {
        for logger in errorLoggers {
            let typeErasedError = AnyPayPalHereError(underlyingError: error)
            logger.errorDidOccur(typeErasedError)
        }
    }
}


