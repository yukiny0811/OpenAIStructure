//
//  OpenAIStructureError.swift
//  OpenAIStructure
//
//  Created by Yuki Kuwashima on 2025/05/02.
//

import Foundation

public struct OpenAIStructureError: LocalizedError {
    public let message: String
    public init(message: String) {
        self.message = message
    }
    public var errorDescription: String? {
        message
    }
}
