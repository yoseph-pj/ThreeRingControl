//
//  Provider.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/28/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//


import Foundation

public struct ProviderObj {
   // public let providerId: String
    public let _id: String
    public let name: String
    public let prddescription: String
    public let version: String
 }

 extension ProviderObj: DictionaryDeserializable, DictionarySerializable {
    public init?(dictionary: JSONDictionary) {
        guard let version = dictionary["__v"] as? String,
            let _id = dictionary["_id"] as? String,
            let prddescription = dictionary["description"] as? String,
            let name = dictionary["name"] as? String else { return nil }
            //let providerId = dictionary["providerId"] as? String else { return nil }
         self.version = version
        self._id = _id
        self.prddescription = prddescription
        self.name = name
       // self.providerId = providerId

    }

    public var dictionary: JSONDictionary {
        return [

            "__v": version,
            "_id": _id,
            "description": prddescription,
            "name": name
           // "providerId": providerId

        ]
    }
}


