import SwiftCompilerPlugin
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

final class PropertyDefinitionInternal: Encodable {
    let type: String?
    let description: String?
    let additionalProperties: Bool?
    let required: [String]?
    let properties: [String: PropertyDefinitionInternal]?
    let items: PropertyDefinitionInternal?

    let structName: String?

    init(
        type: String? = nil,
        description: String? = nil,
        additionalProperties: Bool? = nil,
        required: [String]? = nil,
        properties: [String: PropertyDefinitionInternal]? = nil,
        items: PropertyDefinitionInternal? = nil,
        structName: String? = nil
    ) {
        self.type = type
        self.description = description
        self.additionalProperties = additionalProperties
        self.required = required
        self.properties = properties
        self.items = items
        self.structName = structName
    }

    func compileToString() -> String? {
        guard let type else {
            return nil
        }
        switch type {
        case "boolean":
            let result =
            """
            SchemaRequest.PropertyDefinition(
                type: "boolean",
                description: "\(description ?? "")"
            )
            """
            return result
        case "string":
            let result =
            """
            SchemaRequest.PropertyDefinition(
                type: "string",
                description: "\(description ?? "")"
            )
            """
            return result
        case "number":
            let result =
            """
            SchemaRequest.PropertyDefinition(
                type: "number",
                description: "\(description ?? "")"
            )
            """
            return result
        case "array":
            if let structName {
                let result =
                """
                SchemaRequest.PropertyDefinition(
                    type: "array",
                    description: "\(description ?? "")",
                    items: SchemaRequest.PropertyDefinition(
                        type: "object",
                        additionalProperties: false,
                        required: \(structName).object.required,
                        properties: \(structName).object.properties
                    )
                )
                """
                return result
            } else {
                let result =
                """
                SchemaRequest.PropertyDefinition(
                    type: "array",
                    description: "\(description ?? "")",
                    items: SchemaRequest.PropertyDefinition(
                        type: "\(items?.type ?? "")"
                    )
                )
                """
                return result
            }
        case "object":
            if let structName {
                let result =
                """
                SchemaRequest.PropertyDefinition(
                    type: "object",
                    description: "\(description ?? "")",
                    additionalProperties: false,
                    required: \(structName).object.required,
                    properties: \(structName).object.properties
                )
                """
                return result
            }
        default:
            return nil
        }
        return nil
    }
}

public struct OpenAIStructure: MemberMacro, ExtensionMacro {

    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard let structName = declaration.as(StructDeclSyntax.self)?.name.trimmedDescription else {
            throw "struct name error "
        }
        return [
            try! .init("extension \(raw: structName): OpenAIStructureObject {}")
        ]
    }


    public init(name: String) {}

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        var properties: [String: PropertyDefinitionInternal] = [:]

        // parse name
        guard let nodeArguments = node.arguments else {
            throw "no arguments error"
        }
        guard let nameExpression = nodeArguments.as(LabeledExprListSyntax.self)?.first?.expression else {
            throw "no name expression error"
        }
        guard let name = nameExpression.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content.trimmedDescription else {
            throw "no name error"
        }

        // main
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw "OpenAISchema should be attached to a struct"
        }
        let members = structDecl.memberBlock.members
        for member in members {
            guard let variable = member.decl.as(VariableDeclSyntax.self) else {
                throw "OpenAISchema only supports variables"
            }
            guard let descriptionDecl = variable.attributes.first (where: {
                $0.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "Field"
            }) else {
                continue
            }
            guard let description = descriptionDecl
                .as(AttributeSyntax.self)?.arguments?
                .as(LabeledExprListSyntax.self)?.first?.expression
                .as(StringLiteralExprSyntax.self)?.segments.first?
                .as(StringSegmentSyntax.self)?.content.trimmedDescription else {
                throw "no description error"
            }
            guard let binding = variable.bindings.first else {
                throw "Binding error"
            }
            guard let variableName = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.trimmedDescription else {
                throw "variable name error"
            }
            guard let type = binding.typeAnnotation?.type else {
                throw "variable type error"
            }
            if let identifierSyntax = type.as(IdentifierTypeSyntax.self) {
                let variableType = identifierSyntax.name.trimmedDescription
                switch variableType {
                case "String":
                    let property = PropertyDefinitionInternal(type: "string", description: description)
                    properties[variableName] = property
                case "Bool":
                    let property = PropertyDefinitionInternal(type: "boolean", description: description)
                    properties[variableName] = property
                case "Double":
                    let property = PropertyDefinitionInternal(type: "number", description: description)
                    properties[variableName] = property
                default:
                    let property = PropertyDefinitionInternal(type: "object", description: description, structName: variableType)
                    properties[variableName] = property
                }
            } else if let arraySyntax = type.as(ArrayTypeSyntax.self) {
                guard let arrayItemType = arraySyntax.element.as(IdentifierTypeSyntax.self)?.name.trimmedDescription else {
                    throw "array item type error"
                }
                switch arrayItemType {
                case "String":
                    let property = PropertyDefinitionInternal(type: "array", description: description, items: .init(type: "string"))
                    properties[variableName] = property
                case "Bool":
                    let property = PropertyDefinitionInternal(type: "array", description: description, items: .init(type: "boolean"))
                    properties[variableName] = property
                case "Double":
                    let property = PropertyDefinitionInternal(type: "array", description: description, items: .init(type: "number"))
                    properties[variableName] = property
                default:
                    let property = PropertyDefinitionInternal(type: "array", description: description, structName: arrayItemType)
                    properties[variableName] = property
                }
            }
        }

        var resultPropertiesString: String = ""
        var resultRequiredString: String = ""
        for key in properties.keys {
            if let compiled = properties[key]?.compileToString() {
                resultPropertiesString += "\"\(key)\"" + " : " + compiled + ","
            }
            resultRequiredString += "\"\(key)\","
        }
        if resultPropertiesString.isEmpty {
            resultPropertiesString = ":"
        }


        let decl1: DeclSyntax =
        """
        public static let schema = SchemaRequest(
            name: "\(raw: name)",
            schema: .init(
                required: [\(raw: resultRequiredString)],
                properties: [\(raw: resultPropertiesString)]
            )
        )
        
        public static let object: SchemaRequest.PropertyDefinition = .init(
            type: "object",
            description: "",
            additionalProperties: false,
            required: [\(raw: resultRequiredString)],
            properties: [\(raw: resultPropertiesString)]
        )
        """

        return [decl1]
    }
}

public struct Field: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        []
    }
}

extension String: @retroactive Error {}
extension String: @retroactive LocalizedError {
    public var errorDescription: String? {
        self
    }
}

@main
struct OpenAIStructurePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        OpenAIStructure.self,
        Field.self,
    ]
}
