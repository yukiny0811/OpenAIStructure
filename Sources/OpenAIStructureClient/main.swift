import OpenAIStructure
import Foundation

@OpenAIStructure(name: "talk_theme_pack")
struct TalkThemePack: Codable {

    @Field("Pack metadata")
    var meta: PackMeta

    @Field("Array of talk themes")
    var themes: [TalkTheme]
}

@OpenAIStructure(name: "pack_meta")
struct PackMeta: Codable {

    @Field("Title of the pack")
    var title: String

    @Field("note")
    var note: String
}

@OpenAIStructure(name: "talk_theme")
struct TalkTheme: Codable {

    @Field("Theme title")
    var title: String

    @Field("Theme overview")
    var overview: String

    @Field("Question blocks")
    var questionBlocks: [QuestionBlock]
}

@OpenAIStructure(name: "question_block")
struct QuestionBlock: Codable {

    @Field("Block label")
    var label: String

    @Field("List of questions")
    var questions: [String]
}


do {
    let result = try await OpenAIRequest.request(
        input: "Talk theme related to food.",
        instructions: "Provide some talk themes.",
        model: .o4_mini(reasoningEffort: .low),
        object: TalkThemePack.self,
        apiKey: ""
    )
    print(result)
} catch {
    print(error)
}

