//
//  Coupon.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/29/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//
import Foundation

public struct Coupon {
    public let href: String
    public let _id: String
    public let name: String
    public let prddescription: String
   // public let claims: Claims
    public let provider: Provider
    public let type: Type

}


extension Coupon: DictionaryDeserializable, DictionarySerializable {
    public init?(dictionary: JSONDictionary) {
        guard let href = dictionary["href"] as? String,
            let _id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let prddescription = dictionary["description"] as? String,
            //let claimsDictionary = dictionary["claims"] as? JSONDictionary,
           // let claims = Claims(dictionary: claimsDictionary),
            let providerDictionary = dictionary["provider"] as? JSONDictionary,
            let provider = Provider(dictionary: providerDictionary),
            let typeDictionary = dictionary["type"] as? JSONDictionary,
            let type = Type(dictionary: typeDictionary) else { return nil }


        self.href = href
        self._id = _id
        self.name = name
        self.prddescription = prddescription
       // self.claims = claims
        self.provider = provider
        self.type = type



    }

    public var dictionary: JSONDictionary {
        return [

            "href": href,
            "id": _id,
            "name": name,
            "description": prddescription,
           // "claims": claims,
            "provider": provider,
            "type": type
  
        ]
    }
}


extension Coupon: Hashable {
    public var hashValue: Int {
        return _id.hashValue
    }
}


public func == (lhs: Coupon, rhs: Coupon) -> Bool {
    return lhs._id == rhs._id
}
