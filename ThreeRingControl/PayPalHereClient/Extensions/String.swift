//
//  String.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 12/30/17.
//  Copyright © 2017 Tilahun, Yoseph. All rights reserved.
//

import Foundation

/// Localized string
func localize(_ string: String) -> String {
    return NSLocalizedString(string, comment: "")
}

func localize(_ string: String, _ args: CVarArg...) -> String {
    return String(format: localize(string), arguments: args)
}

/// Pluralize a string
func pluralize(_ count: UInt, singular: String, plural: String) -> String {
    let label = (count == 1) ? localize(singular) : localize(plural)

    // TODO: This localization could be a lot better. I know Mattt's implementation handles basically
    // everything: https://github.com/mattt/TTTLocalizedPluralString
    return "\(count) \(label)"
}

