//
//  Error.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/28/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

/// Error struct, having human readable title and message
public struct Error {

    public struct Link: DictionaryDeserializable {
        public let title: String
       // public let url: URL

        public init?(dictionary: JSONDictionary) {
            guard let title = dictionary["title"] as? String
              //  let url = (dictionary["url"] as? String).flatMap(URL.init)
                else { return nil }

            self.title = title
           // self.url = url
        }
    }

    public let code: Int?
    public var title: String
    public var message: String
    public var links: [Link]

    public init() {
        self.init(title: localize("UNKNOWN_ERROR_TITLE"), message: localize("UNKNOWN_ERROR_MESSAGE"), code: nil)
    }

    public init(title: String, message: String, code: Int? = nil, links: [Link] = []) {
        self.title = title
        self.message = message
        self.code = code
        self.links = links
    }
}


extension Error: DictionaryDeserializable {
    /// Optional initializer that parse simple and multiple error response from the server
    public init?(dictionary: JSONDictionary) {
        guard let dictionary = dictionary["error"] as? JSONDictionary else { return nil }

        if let errors = dictionary["errors"] as? [JSONDictionary] {
            // Handle V5 errors
            let title = dictionary["message"] as? String ?? localize("UNKNOWN_ERROR_TITLE")
            let message = errors.flatMap { $0["message"] as? String }.joined(separator: "\n")

            let linksDictionaries = errors.flatMap { $0["links"] as? [JSONDictionary] }.joined()
            let links = linksDictionaries.flatMap(Link.init)

            let code = dictionary["code"] as? Int

            self.init(title: title, message: message, code: code, links: links)
        } else if let message = dictionary["message"] as? String, let code = dictionary["code"] as? Int {
            // If the server does not return a title, resort to the default title
            let title = dictionary["title"] as? String ?? localize("UNKNOWN_ERROR_TITLE")

            let links: [Link]
            if let linksDictionaries = dictionary["links"] as? [JSONDictionary] {
                links = linksDictionaries.flatMap(Link.init)
            } else {
                links = []
            }

            self.init(title: title, message: message, code: code, links: links)
        } else {
            return nil
        }
    }
}

