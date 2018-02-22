//
//  MultipartForm.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/28/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

import Foundation

private let CRLF = "\r\n"


private protocol FormDataType {
    var data: Data { get }
}


public struct BodyPart: FormDataType {
    fileprivate let headers: [String: String]
    public let name: String
    public let fileName: String?
    public let mimeType: String?
    public let rawData: Data

    static func serialize(_ parameters: [String: String]) -> [BodyPart] {
        return parameters.flatMap {
            return BodyPart(name: $0, value: $1)
        }
    }

    public init(name: String, fileName: String, mimeType: String, data: Data) {
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
        self.rawData = data

        self.headers = [
            "Content-Disposition" : "form-data; name=\"\(name)\"; filename=\"\(fileName)\"",
            "Content-Type" : mimeType
        ]
    }

    public init?(name: String, value: String) {
        guard let data = value.data(using: .utf8) else { return nil }
        self.rawData = data
        self.fileName = nil
        self.mimeType = nil
        self.name = name
        self.headers = ["Content-Disposition" : "form-data; name=\"\(name)\""]
    }

    public var data: Data {
        let headerString = headers.reduce("") {
            return $0 + "\($1.0): \($1.1)\(CRLF)"
            } + "\(CRLF)"

        var data = Data()
        guard let headerData = headerString.data(using: .utf8) else { return Data() }
        data.append(headerData)
        data.append(self.rawData)
        return data
    }
}


public enum FormDataKind {
    case boundary(ThreeRingControl.Boundary)
    case bodyPart(ThreeRingControl.BodyPart)
}


public enum Boundary: FormDataType {
    case initial(String)
    case encapsulated(String)
    case final(String)

    public var boundaryValue: String {
        switch self {
        case .initial(let string): return "--\(string)\(CRLF)"
        case .encapsulated(let string): return "\(CRLF)--\(string)\(CRLF)"
        case .final(let string): return "\(CRLF)--\(string)--\(CRLF)"
        }
    }

    public var data: Data {
        return boundaryValue.data(using: .utf8)!
    }
}


public struct FormData {
    fileprivate let formData: [FormDataType]
    public let contentLength: UInt
    public let data: Data

    public init(bodyParts: [BodyPart], boundaryValue: String) {
        var formData: [FormDataType] = [Boundary.initial(boundaryValue)]

        bodyParts.forEach {
            formData.append($0)
            formData.append(Boundary.encapsulated(boundaryValue))
        }

        formData.removeLast()
        formData.append(Boundary.final(boundaryValue))

        self.formData = formData
        self.contentLength = bodyParts.reduce(0) { $0 + UInt($1.data.count) }

        var data = Data()
        for formDatum in self.formData {
            data.append(formDatum.data)
        }
        self.data = data
    }
}

