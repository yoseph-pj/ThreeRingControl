//
//  LoggableEvents.swift
//  ThreeRingControl
//
//  Created by Tilahun, Yoseph on 2/22/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//
import Foundation

public protocol NetworkingLoggable {
    func willPerform(_ task: URLSessionDataTask)
    func didPerform(_ request: URLRequest, data: Data?, response: HTTPURLResponse?, error: NSError?)
}

public protocol DeserializationLoggable {
    func willAttemptDeserialization(of data: Data)
    func didAttemptDeserialization(of data: Data, result: Result<Any, AnyPayPalHereError>)
}

public protocol ErrorLoggable {
    func errorDidOccur(_ error: AnyPayPalHereError)
}


