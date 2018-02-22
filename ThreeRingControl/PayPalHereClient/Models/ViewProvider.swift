//
//  ViewProvider.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/29/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

import UIKit


@objc class ViewProvider: NSObject {
    let providerId: String?
    let _id: String?
    let name: String?
    let prddescription: String?
    let version: String?



    init(providerId: String, _id: String,  name: String,  prddescription: String, version: String) {
        self.providerId = providerId
        self._id = _id
        self.name = name
        self.prddescription = prddescription
        self.version = version
    }



}
