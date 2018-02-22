//
//  DictionaryDeserialization.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 12/29/17.
//  Copyright © 2017 Tilahun, Yoseph. All rights reserved.
//


public typealias JSONDictionary = [String: Any]

public protocol DictionaryDeserializable {
    init?(dictionary: JSONDictionary)
}

public protocol DictionarySerializable {
    var dictionary: JSONDictionary { get }
}

