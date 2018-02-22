//
//  Provider.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/29/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//



public struct Provider {
    public let href: String
    public let _id: String


}

extension Provider: DictionaryDeserializable, DictionarySerializable {
    public init?(dictionary: JSONDictionary) {
        guard let href = dictionary["href"] as? String,
            let _id = dictionary["id"] as? String else { return nil }

        self.href = href
        self._id = _id

    }

    public var dictionary: JSONDictionary {
        return [

            "href": href,
            "id": _id

        ]
    }
}


