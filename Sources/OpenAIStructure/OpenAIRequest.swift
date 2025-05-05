//
//  OpenAIRequest.swift
//  OpenAIStructure
//
//  Created by Yuki Kuwashima on 2025/05/02.
//

import Foundation

public enum OpenAIRequest {
    public static let endpoint = URL(string: "https://api.openai.com/v1/responses")!

    public struct Payload<Schema: Codable>: Codable {
        let model: String
        let input: String
        let reasoning: Reasoning
        let instructions: String
        let text: TextObject
        public struct Reasoning: Codable {
            let effort: String?
        }
        public struct TextObject: Codable {
            let format: Schema
        }
    }

    public static func request<T: OpenAIStructureObject>(input: String, instructions: String, model: OpenAIModel, object: T.Type, apiKey: String) async throws -> T {
        var req = URLRequest(url: endpoint)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        let payload: Payload<SchemaRequest>
        if model.hasReasoning, case let OpenAIModel.o4_mini(reasoningEffort) = model {
            payload = Payload(
                model: model.modelName,
                input: input,
                reasoning: .init(
                    effort: reasoningEffort.rawValue
                ),
                instructions: instructions,
                text: .init(
                    format: T.schema
                )
            )
        } else {
            payload = Payload(
                model: model.modelName,
                input: input,
                reasoning: .init(effort: nil),
                instructions: instructions,
                text: .init(
                    format: T.schema
                )
            )
        }
        req.httpBody = try JSONEncoder().encode(payload)
        req.timeoutInterval = 300
        let (data, _) = try await URLSession.shared.data(for: req)
        guard let decoded = try? JSONDecoder().decode(OpenAIResponse.self, from: data) else {
            throw OpenAIStructureError(message: String(data: data, encoding: .utf8) ?? "error")
        }
        let text = decoded.output.last!.content!.last!.text!
        let result = try JSONDecoder().decode(T.self, from: text.data(using: .utf8)!)
        return result
    }

    public struct PayloadWithImage<Schema: Codable>: Codable {
        let model: String
        let input: [Input]
        let reasoning: Reasoning
        let instructions: String
        let text: TextObject
        public struct Reasoning: Codable {
            let effort: String?
        }
        public struct TextObject: Codable {
            let format: Schema
        }
        public struct Input: Codable {
            var role: String
            var content: [Content]
            init(content: [Content]) {
                self.role = "user"
                self.content = content
            }
            struct Content: Codable {
                var type: String
                var detail: String?
                var image_url: String?
                var text: String?
            }
        }
    }

    public static func request<T: OpenAIStructureObject>(input: String, instructions: String, image: Data, model: OpenAIModel, object: T.Type, apiKey: String) async throws -> T {
        var req = URLRequest(url: endpoint)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        let payload: PayloadWithImage<SchemaRequest>
        if model.hasReasoning, case let OpenAIModel.o4_mini(reasoningEffort) = model {
            payload = PayloadWithImage(
                model: model.modelName,
                input: [
                    .init(
                        content: [
                            .init(type: "input_text", text: input),
                            .init(type: "input_image", detail: "high", image_url: "data:image/jpeg;base64," + image.base64EncodedString())
                        ]
                    )
                ],
                reasoning: .init(effort: reasoningEffort.rawValue),
                instructions: instructions,
                text: .init(format: T.schema)
            )
        } else {
            payload = PayloadWithImage(
                model: model.modelName,
                input: [
                    .init(
                        content: [
                            .init(type: "input_text", text: input),
                            .init(type: "input_image", detail: "high", image_url: "data:image/jpeg;base64," + image.base64EncodedString())
                        ]
                    )
                ],
                reasoning: .init(effort: nil),
                instructions: instructions,
                text: .init(format: T.schema)
            )
        }
        req.httpBody = try JSONEncoder().encode(payload)
        req.timeoutInterval = 300
        let (data, _) = try await URLSession.shared.data(for: req)
        guard let decoded = try? JSONDecoder().decode(OpenAIResponse.self, from: data) else {
            throw OpenAIStructureError(message: String(data: data, encoding: .utf8) ?? "error")
        }
        let text = decoded.output.last!.content!.last!.text!
        let result = try JSONDecoder().decode(T.self, from: text.data(using: .utf8)!)
        return result
    }
}
