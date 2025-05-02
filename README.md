# OpenAIStructure

**Swift Macro for OpenAI API Structured Outputs.**

## Usage

Just attach OpenAIStructure Macro to your struct, and provide description for every fields using Field Macro.

```swift
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
```

```swift
let result: TalkThemePack = try await OpenAIRequest.request(
    input: "Talk theme related to food.",
    instructions: "Provide some talk themes.",
    model: .o4_mini(reasoningEffort: .low),
    object: TalkThemePack.self,
    apiKey: "<your_api_key>"
)
```

## Notice

Optimised for the *Responses API* with one `prompt` in, one `structured object` out.
