import OpenAIStructure
import Foundation
import AppKit

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
        apiKey: ""
    )
    print(result)
} catch {
    print(error)
}

print("-------image-------")

@OpenAIStructure(name: "describe_image")
struct ImageDescriber {

    @Field("description of the image")
    var image_description: String
}

do {
    let cgImage = Bundle.module.image(forResource: "apple")!.cgImage(forProposedRect: nil, context: nil, hints: nil)!
    let rep = NSBitmapImageRep(cgImage: cgImage)
    let imageData = rep.representation(using: .png, properties: [:])!
    let result = try await OpenAIRequest.request(
        input: "Talk theme related to food.",
        instructions: "Provide some talk themes.",
        image: imageData,
        model: .gpt4_1_nano,
        object: ImageDescriber.self,
        apiKey: ""
    )
    print(result)
} catch {
    print(error)
}
