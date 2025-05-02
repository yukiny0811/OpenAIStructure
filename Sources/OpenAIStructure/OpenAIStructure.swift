@attached(
    member,
    names:
        named(schema),
        named(object)
)
@attached(
    extension,
    conformances: OpenAIStructureObject,
    names: named(schema), named(object)
)
public macro OpenAIStructure(name: String) = #externalMacro(module: "OpenAIStructureMacros", type: "OpenAIStructure")

@attached(
    peer
)
public macro Field(_ description: String) = #externalMacro(module: "OpenAIStructureMacros", type: "Field")
