//
//  SchemaRequest.swift
//  OpenAIStructure
//
//  Created by Yuki Kuwashima on 2025/05/02.
//

import Foundation

public struct SchemaRequest: Codable, Sendable {
    public let name: String
    public let strict: Bool
    public let schema: Schema
    public let type: String

    public init(name: String, schema: Schema) {
        self.name = name
        self.schema = schema
        self.strict = true
        self.type = "json_schema"
    }

    public struct Schema: Codable, Sendable {
        public let type: String
        public let additionalProperties: Bool
        public let required: [String]
        public let properties: [String: PropertyDefinition]

        public init(required: [String], properties: [String : PropertyDefinition]) {
            self.required = required
            self.properties = properties
            self.type = "object"
            self.additionalProperties = false
        }
    }

    public final class PropertyDefinition: Codable, Sendable {
        public let type: String?
        public let description: String?
        public let additionalProperties: Bool?
        public let required: [String]?
        public let properties: [String: PropertyDefinition]?
        public let items: PropertyDefinition?

        public init(
            type: String? = nil,
            description: String? = nil,
            additionalProperties: Bool? = nil,
            required: [String]? = nil,
            properties: [String: PropertyDefinition]? = nil,
            items: PropertyDefinition? = nil
        ) {
            self.type = type
            self.description = description
            self.additionalProperties = additionalProperties
            self.required = required
            self.properties = properties
            self.items = items
        }
    }
}
