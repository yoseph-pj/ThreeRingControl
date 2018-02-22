

//
//  PayPalHereClient+ConnectionCounter.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/28/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//


import Foundation

public protocol ClientCounterDelegate { // swiftlint:disable:this class_delegate_protocol
    func connectionCountDidChange(connectionCount: UInt)
}

extension PayPalHereClient {
    public static var connectionCountDelegate: ClientCounterDelegate?

    fileprivate static var privateConnectionCount: UInt = 0 {
        didSet {
            if let connectionCountDelegate = connectionCountDelegate {
                let count = privateConnectionCount
                DispatchQueue.main.async {
                    connectionCountDelegate.connectionCountDidChange(connectionCount: count)
                }
            }
        }
    }
    fileprivate static let queue = DispatchQueue(label: "com.paypal.paypalclient.ClientConnectionCounter", attributes: [])

    internal static func incrementConnectionCount() {
        queue.sync {
            privateConnectionCount += 1
        }
    }

    internal static func decrementConnectionCount() {
        queue.sync {
            if privateConnectionCount > 0 {
                privateConnectionCount -= 1
            }
        }
    }
}
