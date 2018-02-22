//
//  Claims.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/29/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//


public struct Claims {
    public let totalAllowed: String
    public let totalMade: String
    public let isAvailable: String
    public let href: String
    public let version: String


}


extension Claims: DictionaryDeserializable, DictionarySerializable {
    public init?(dictionary: JSONDictionary) {
        guard let totalAllowed = dictionary["totalAllowed"] as? String,
            let totalMade = dictionary["totalMade"] as? String,
            let isAvailable = dictionary["isAvailable"] as? String,
            let href = dictionary["href"] as? String else { return nil }
            

        self.totalAllowed = totalAllowed
        self.totalMade = totalMade
        self.isAvailable = isAvailable
        self.href = href
        self.version = "1.0"



    }

    public var dictionary: JSONDictionary {
        return [

            "totalAllowed": totalAllowed,
            "totalMade": totalMade,
            "isAvailable": isAvailable,
            "href": href,
            "version": version

        ]
    }
}


extension Claims: Hashable {
    public var hashValue: Int {
        return href.hashValue
    }
}


public func == (lhs: Claims, rhs: Claims) -> Bool {
    return lhs.href == rhs.href
}

