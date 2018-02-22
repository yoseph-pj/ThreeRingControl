//
//  KeyValueObserver.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/28/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

import Foundation

// Source: https://medium.com/proto-venture-technology/the-state-of-kvo-in-swift-aa5cb1e05cba
open class KeyValueObserver: NSObject {

    // MARK: - Typealias

    public typealias Callback = (_ change: [NSKeyValueChangeKey : Any]?) -> Void


    // MARK: - Properties

    open var callback: Callback?

    fileprivate let object: NSObject
    fileprivate let keyPath: String
    fileprivate var kvoContext = 0


    // MARK: - Initializers

    public init(object: NSObject, keyPath: String, options: NSKeyValueObservingOptions, callback: Callback? = nil) {
        self.object = object
        self.keyPath = keyPath
        self.callback = callback
        super.init()
        object.addObserver(self, forKeyPath: keyPath, options: options, context: &kvoContext)
    }

    deinit {
        object.removeObserver(self, forKeyPath: keyPath, context: &kvoContext)
    }


    // MARK: - NSObject

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &kvoContext {
            self.callback?(change)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

