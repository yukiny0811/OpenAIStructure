//
//  OpenAIResponse.swift
//  OpenAIStructure
//
//  Created by Yuki Kuwashima on 2025/05/02.
//

import Foundation

struct OpenAIResponse: Codable, Sendable {
    /// "resp_…"
    let id: String
    let object: String
    let createdAt: Int
    let status: String
    let model: String
    let output: [Output]
    let parallelToolCalls: Bool
    let previousResponseID: String?
    let reasoning: Reasoning
    let serviceTier: String
    let store: Bool
    let temperature: Double
    let text: TextContainer
    let toolChoice: String
    let tools: [AnyCodable]
    let topP: Double
    let truncation: String
    let usage: Usage
    let user: String?
    let metadata: [String: String]

    enum CodingKeys: String, CodingKey {
        case id, object, status, model, output, reasoning, store, temperature,
             text, tools, usage, user, metadata, truncation
        case createdAt           = "created_at"
        case parallelToolCalls   = "parallel_tool_calls"
        case previousResponseID  = "previous_response_id"
        case serviceTier         = "service_tier"
        case toolChoice          = "tool_choice"
        case topP                = "top_p"
    }
}

struct Output: Codable, Sendable {
    let id: String
    let type: String
    let summary: [String]?
    let status: String?
    let content: [Content]?
    let role: String?
}

struct Content: Codable, Sendable {
    let type: String
    let annotations: [AnyCodable]
    let text: String?
}

struct Reasoning: Codable {
    let effort: String?
    let summary: String?
}

struct TextContainer: Codable, Sendable {
    let format: Format
}

struct Format: Codable, Sendable {
    let type: String
    let description: String?
    let name: String?
    let schema: AnyCodable?
    let strict: Bool?
}

struct Usage: Codable {
    let input_tokens: Int
    let input_tokens_details: TokenDetails
    let output_tokens: Int
    let output_tokens_details: TokenDetails
    let total_tokens: Int
}

struct TokenDetails: Codable {
    let cached_tokens: Int?
    let reasoning_tokens: Int?
}
