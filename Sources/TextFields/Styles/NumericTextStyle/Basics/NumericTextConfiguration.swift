//
//  NumericTextConfiguration.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-22.
//

// MARK: - NumericTextConfiguration

@usableFromInline final class NumericTextConfiguration {
    @usableFromInline typealias Components = NumericTextComponents
    @usableFromInline typealias Signs = NumericTextConfigurationSigns
    @usableFromInline typealias Digits = NumericTextConfigurationDigits
    @usableFromInline typealias Separators = NumericTextConfigurationSeparators
    @usableFromInline typealias Options = NumericTextConfigurationOptions
    
    // MARK: Properties
    
    @usableFromInline var signs: Signs
    @usableFromInline var digits: Digits
    @usableFromInline var separators: Separators
    @usableFromInline var options: Options
    
    // MARK: Initializers
    
    @inlinable init(signs: Signs = Signs(), digits: Digits = Digits(), separators: Separators = Separators(), options: Options = Options()) {
        self.signs = signs
        self.digits = digits
        self.separators = separators
        self.options = options
    }
    
    // MARK: Utilities
    
    @inlinable func components(_ characters: String) -> Components? {
        // --------------------------------- //
        
        var components = Components()
        var index = characters.startIndex
        
        // --------------------------------- //
        
        func done() -> Bool {
            index == characters.endIndex
        }
        
        // --------------------------------- //
        
        signs.parse(characters, from: &index, into: &components.sign)
        
        if options.contains(.nonnegative) {
            guard components.sign != .negative else { return nil }
        }
        
        // --------------------------------- //
        
        digits.parse(characters, from: &index, into: &components.integers)
        
        if options.contains(.integer) {
            guard done() else { return nil }
            
            return components
        }
        
        // --------------------------------- //
        
        separators.parse(characters, from: &index, into: &components.separator)
        
        if components.separator == nil {
            guard done() else { return nil }
            
            return components
        }
        
        // --------------------------------- //

        digits.parse(characters, from: &index, into: &components.decimals)
        
        if components.decimals.isEmpty {
            guard done() else { return nil }
            
            return components
        }
        
        // --------------------------------- //
                
        guard done() else { return nil }
        
        // --------------------------------- //
        
        return components
        
        // --------------------------------- //
    }
}

// MARK: - NumericTextConfigurationSigns

@usableFromInline struct NumericTextConfigurationSigns {
    @usableFromInline typealias Sign = NumericTextComponents.Sign
    
    @usableFromInline static let positives: Self = .init(positives: [Sign.plus],  negatives: [])
    @usableFromInline static let negatives: Self = .init(positives: [], negatives: [Sign.minus])
    
    // MARK: Properties
    
    @usableFromInline var positives: [String]
    @usableFromInline var negatives: [String]
    
    // MARK: Initializers
    
    @inlinable init() {
        self.init(positives: [Sign.plus], negatives: [Sign.minus])
    }
    
    @inlinable init(positives: [String], negatives: [String]) {
        self.positives = positives
        self.negatives = negatives
    }
    
    // MARK: Utilities
    
    @inlinable func interpret(_ characters: String) -> Sign? {
        if negatives.contains(characters) { return .negative }
        if positives.contains(characters) { return .positive }
        
        return nil
    }
    
    // MARK: Helpers
    
    @inlinable func parse(_ characters: String, from index: inout String.Index, into storage: inout Sign?) {
        let subsequence = characters[index...]
                
        func parse(_ signs: [String], success: Sign) -> Bool {
            for sign in signs {
                guard subsequence.hasPrefix(sign) else { continue }
                
                storage = success
                index = subsequence.index(index, offsetBy: sign.count)
                return true
            }
            
            return false
        }
        
        if parse(negatives, success: .negative) { return }
        if parse(positives, success: .positive) { return }
        
        storage = nil
    }
}

// MARK: - NumericTextConfigurationSeparators

@usableFromInline struct NumericTextConfigurationSeparators {
    @usableFromInline typealias Separator = NumericTextComponents.Separator
    
    // MARK: Properties

    @usableFromInline var translatables: [String]
    
    // MARK: Initializers
    
    @inlinable init() {
        self.translatables = [Separator.system.characters]
    }
    
    // MARK: Transformations
    
    @inlinable mutating func insert(_ separator: String) {
        translatables.append(separator)
    }
    
    @inlinable mutating func insert(contentsOf separators: [String]) {
        translatables.append(contentsOf: separators)
    }
    
    // MARK: Helpers

    @inlinable func parse(_ characters: String, from index: inout String.Index, into storage: inout Separator?) {
        let subsequence = characters[index...]
        
        for translatable in translatables {
            guard subsequence.hasPrefix(translatable) else { continue }
            
            storage = .system
            index = subsequence.index(index, offsetBy: translatable.count)
            return
        }
        
        storage = nil
    }
}

// MARK: - NumericTextConfigurationDigits

@usableFromInline struct NumericTextConfigurationDigits {
    @usableFromInline typealias Digits = NumericTextComponents.Digits
    
    // MARK: Properties
    
    @usableFromInline let digits: Set<Character>
    
    // MARK: Initializers
    
    @inlinable init() {
        self.digits = Digits.set
    }
    
    // MARK: Helpers

    @inlinable func parse(_ characters: String, from index: inout String.Index, into storage: inout Digits) {
        for character in characters[index...] {
            guard digits.contains(character) else { return }
            
            storage.append(character)
            index = characters.index(after: index)
        }
    }
}

// MARK: - NumericTextConfigurationOptions

@usableFromInline struct NumericTextConfigurationOptions: OptionSet {
    @usableFromInline static let integer     = Self(rawValue: 1 << 0)
    @usableFromInline static let nonnegative = Self(rawValue: 1 << 1)
    
    // MARK: Properties
    
    @usableFromInline let rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
}
