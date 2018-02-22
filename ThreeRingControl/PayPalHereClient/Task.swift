//
//  Task.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/28/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

import Foundation

extension PayPalHereClient {

    public struct Task {

        // MARK: - Public Properties

        public var uploadProgressDidChange: ((_ progress: Double, _ countOfBytesSent: UInt, _ countOfBytesExpectedToSend: UInt) -> Void)? {
            didSet {
                guard uploadProgressDidChange != nil else {
                    uploadBytesObservers = nil
                    return
                }
                let sentBytesObserver = KeyValueObserver(object: task, keyPath: "countOfBytesSent", options: .new)
                let expectedToSendBytesObserver = KeyValueObserver(object: task, keyPath: "countOfBytesExpectedToSend", options: .new)

                sentBytesObserver.callback = uploadProgressHandler
                expectedToSendBytesObserver.callback = uploadProgressHandler
                uploadBytesObservers = (sentBytesObserver, expectedToSendBytesObserver)
            }
        }

        public var downloadProgressDidChange: ((_ progress: Double, _ countOfBytesReceived: UInt, _ countOfBytesExpectedToReceive: UInt) -> Void)? {
            didSet {
                guard downloadProgressDidChange != nil else {
                    downloadBytesObservers = nil
                    return
                }
                let receivedBytesObserver = KeyValueObserver(object: task, keyPath: "countOfBytesReceived", options: .new)
                let expectedToReceiveBytesObserver = KeyValueObserver(object: task, keyPath: "countOfBytesExpectedToReceive", options: .new)

                receivedBytesObserver.callback = downloadProgressHandler
                expectedToReceiveBytesObserver.callback = downloadProgressHandler
                downloadBytesObservers = (receivedBytesObserver, expectedToReceiveBytesObserver)
            }
        }

        public var uploadProgress: Double {
            let total =  Double(task.countOfBytesSent + task.countOfBytesExpectedToSend)
            guard total != 0 else { return 0 }
            return Double(task.countOfBytesSent) / total
        }

        public var downloadProgress: Double {
            let total =  Double(task.countOfBytesReceived + task.countOfBytesExpectedToReceive)
            guard total != 0 else { return 0 }
            return Double(task.countOfBytesReceived) / total
        }

        public var countOfBytesSent: UInt {
            return UInt(task.countOfBytesSent)
        }

        public var countOfBytesExpectedToSend: UInt {
            return UInt(task.countOfBytesExpectedToSend)
        }

        public var countOfBytesReceived: UInt {
            return UInt(task.countOfBytesReceived)
        }

        public var countOfBytesExpectedToReceive: UInt {
            return UInt(task.countOfBytesExpectedToReceive)
        }


        // MARK: - Private Properties

        fileprivate let callbackQueue: DispatchQueue

        fileprivate let task: URLSessionTask

        fileprivate var uploadBytesObservers: (bytesMoved: KeyValueObserver, bytesToMove: KeyValueObserver)?
        fileprivate var downloadBytesObservers: (bytesMoved: KeyValueObserver, bytesToMove: KeyValueObserver)?



        // MARK: - Initializers

        init(task: URLSessionTask, callbackQueue: DispatchQueue) {
            self.task = task
            self.callbackQueue = callbackQueue
        }


        // MARK: - Tasks

        /// Cancel the task.
        public func cancel() {
            task.cancel()
        }


        // MARK: - Private

        fileprivate func uploadProgressHandler (_ change: [NSKeyValueChangeKey : Any]?) {
            guard let uploadProgressDidChange = uploadProgressDidChange else { return }
            performOnCallbackQueue(uploadProgressDidChange)(progress: uploadProgress, countOfBytesSent: countOfBytesSent, countOfBytesExpectedToSend:countOfBytesExpectedToSend)
        }

        fileprivate func downloadProgressHandler (_ change: [NSKeyValueChangeKey : Any]?) {
            guard let downloadProgressDidChange = downloadProgressDidChange else { return }
            performOnCallbackQueue(downloadProgressDidChange)(progress: downloadProgress, countOfBytesReceived: countOfBytesReceived, countOfBytesExpectedToReceive: countOfBytesExpectedToReceive)

        }

        fileprivate func performOnCallbackQueue<T>(_ completion: @escaping (T) -> Void) -> ((T) -> Void) {
            return { [unowned callbackQueue] result in
                callbackQueue.async(execute: { completion(result) })
            }
        }
    }
}

extension PayPalHereClient.Task: Equatable { }

public func == (lhs: PayPalHereClient.Task, rhs: PayPalHereClient.Task) -> Bool {
    return lhs.task == rhs.task
}

extension PayPalHereClient.Task: Hashable {
    public var hashValue: Int {
        return task.hashValue
    }
}
