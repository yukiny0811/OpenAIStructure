//
//  OpenAIModel.swift
//  OpenAIStructure
//
//  Created by Yuki Kuwashima on 2025/05/02.
//

import Foundation

public enum ReasoningEffort: String, Codable {
    case high
    case medium
    case low
}

public enum OpenAIModel {
    case gpt4_1
    case gpt4_1_mini
    case gpt4_1_nano
    case o4_mini(reasoningEffort: ReasoningEffort)

    var modelName: String {
        switch self {
        case .gpt4_1:
            "gpt-4.1"
        case .gpt4_1_mini:
            "gpt-4.1-mini"
        case .gpt4_1_nano:
            "gpt-4.1-nano"
        case .o4_mini:
            "o4-mini"
        }
    }

    var hasReasoning: Bool {
        switch self {
        case .gpt4_1, .gpt4_1_mini, .gpt4_1_nano:
            false
        case .o4_mini:
            true
        }
    }
}
