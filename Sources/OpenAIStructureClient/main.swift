import OpenAIStructure
import Foundation

@OpenAIStructure(name: "talk_theme_pack")
struct TalkThemePack {

    @Field("Pack metadata")
    var meta: PackMeta

    @Field("Array of talk themes")
    var themes: [TalkTheme]
}

@OpenAIStructure(name: "pack_meta")
struct PackMeta {

    @Field("Title of the pack")
    var title: String

    @Field("note")
    var note: String
}

@OpenAIStructure(name: "talk_theme")
struct TalkTheme {

    @Field("Theme title")
    var title: String

    @Field("Theme overview")
    var overview: String

    @Field("Question blocks")
    var questionBlocks: [QuestionBlock]
}

@OpenAIStructure(name: "question_block")
struct QuestionBlock {

    @Field("Block label")
    var label: String

    @Field("List of questions")
    var questions: [String]
}


do {
    let result = try await OpenAIRequest.request(
        input: "Talk theme related to food.",
        instructions: "Provide some talk themes.",
        model: .gpt4_1_nano,
        object: TalkThemePack.self,
        apiKey: "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"
    )
    print(result)
} catch {
    print(error)
}

