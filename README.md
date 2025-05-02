# OpenAIStructure

[![Release](https://img.shields.io/github/v/release/yukiny0811/OpenAIStructure)](https://github.com/yukiny0811/OpenAIStructure/releases/latest)
[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2FOpenAIStructure%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/yukiny0811/OpenAIStructure)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2FOpenAIStructure%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/yukiny0811/OpenAIStructure)
[![License](https://img.shields.io/github/license/yukiny0811/OpenAIStructure)](https://github.com/yukiny0811/OpenAIStructure/blob/main/LICENSE)

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
    object: TalkTheme.self,
    apiKey: "<your_api_key>"
)
```

## Notice

Optimised for the *Responses API* with one `prompt` in, one `structured object` out.
