//
//  OpenAIStructureObject.swift
//  OpenAIStructure
//
//  Created by Yuki Kuwashima on 2025/05/02.
//

import Foundation

public protocol OpenAIStructureObject: Codable, Sendable {
    static var schema: SchemaRequest { get }
    static var object: SchemaRequest.PropertyDefinition { get }
}
