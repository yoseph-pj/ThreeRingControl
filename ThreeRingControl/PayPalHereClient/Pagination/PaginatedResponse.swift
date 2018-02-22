//
//  PaginatedResponse.swift
//  ThreeRingControl
//
//  Created by Tilahun, Yoseph on 2/22/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

import Foundation

internal struct PaginatedResponse {

    internal let dictionaries: [JSONDictionary]
    internal let previousURL: URL?
    internal let nextURL: URL?

    internal init?(dictionary: JSONDictionary) {
        guard let dictionaries = dictionary["data"] as? [JSONDictionary],
            let paginationDictionary = dictionary["pagination"] as? JSONDictionary else { return nil }

        self.dictionaries = dictionaries
        self.previousURL = (paginationDictionary["previous"] as? String).flatMap { URL(string: $0) }
        self.nextURL = (paginationDictionary["next"] as? String).flatMap { URL(string: $0) }
    }
}
