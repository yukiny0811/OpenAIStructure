//
//  AnyCodable.swift
//  OpenAIStructure
//
//  Created by Yuki Kuwashima on 2025/05/02.
//

import Foundation

public struct AnyCodable: Codable, @unchecked Sendable {
    public let value: Any

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self.value = ()
        } else if let b = try? container.decode(Bool.self) {
            self.value = b
        } else if let i = try? container.decode(Int.self) {
            self.value = i
        } else if let d = try? container.decode(Double.self) {
            self.value = d
        } else if let s = try? container.decode(String.self) {
            self.value = s
        } else if let a = try? container.decode([AnyCodable].self) {
            self.value = a.map(\.value)
        } else if let o = try? container.decode([String: AnyCodable].self) {
            self.value = o.mapValues(\.value)
        } else {
            throw DecodingError.dataCorruptedError(in: container,
                debugDescription: "Unsupported JSON type")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case is Void:             try container.encodeNil()
        case let b as Bool:       try container.encode(b)
        case let i as Int:        try container.encode(i)
        case let d as Double:     try container.encode(d)
        case let s as String:     try container.encode(s)
        case let a as [Any]:      try container.encode(a.map { AnyCodable(value: $0) })
        case let o as [String: Any]:
            try container.encode(o.mapValues { AnyCodable(value: $0) })
        default:
            throw EncodingError.invalidValue(value, .init(
                codingPath: container.codingPath,
                debugDescription: "Unsupported JSON type"
            ))
        }
    }

    init(value: Any) { self.value = value }
}
