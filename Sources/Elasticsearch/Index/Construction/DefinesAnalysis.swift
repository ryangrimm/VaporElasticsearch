
public protocol DefinesAnalyzers {
    func definedAnalyzers() -> [Analyzer]
}

public protocol DefinesTokenizers {
    func definedTokenizers() -> [Tokenizer]
}

public protocol DefinesNormalizers {
    func definedNormalizers() -> [Normalizer]
}

public protocol DefinesCharacterFilters {
    func definedCharacterFilters() -> [CharacterFilter]
}

public protocol DefinesTokenFilters {
    func definedTokenFilters() -> [TokenFilter]
}
