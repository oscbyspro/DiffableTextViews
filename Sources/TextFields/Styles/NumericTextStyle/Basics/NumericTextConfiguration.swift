//
//  NumericTextComponentsStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-22.
//

// MARK: - NumericTextComponentsStyle

@usableFromInline final class NumericTextConfiguration {
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
}

// MARK: - NumericTextConfigurationSigns

@usableFromInline struct NumericTextConfigurationSigns {
    @usableFromInline typealias Sign = NumericTextComponents.Sign
    
    // MARK: Properties
    
    @usableFromInline var positives: [String]
    @usableFromInline var negatives: [String]
    
    // MARK: Initializers
    
    @inlinable init(positives: [String] = [Sign.positive.rawValue], negatives: [String] = [Sign.negative.rawValue]) {
        self.positives = positives
        self.negatives = negatives
    }
    
    // MARK: Utilities
    
    @inlinable func interpret(_ characters: String) -> Sign {
        if positives.contains(characters) { return .positive }
        if negatives.contains(characters) { return .negative }
        return .none
    }
    
    // MARK: Parses
    
    @inlinable func parse(_ characters: String, from index: inout String.Index, into storage: inout Sign) {
        let subsequence = characters[index...]
                
        func parse(_ signs: [String], success: Sign) {
            for sign in signs {
                guard subsequence.hasPrefix(sign) else { continue }
                
                storage = success
                index = subsequence.index(index, offsetBy: sign.count)
            }
        }
        
        if storage == .none {
            parse(negatives, success: .negative)
        }

        if storage == .none {
            parse(positives, success: .positive)
        }
    }
}

// MARK: - NumericTextConfigurationSeparators

@usableFromInline struct NumericTextConfigurationSeparators {
    @usableFromInline typealias Separator = NumericTextComponents.Separator
    
    // MARK: Properties

    @usableFromInline var translatables: [String]
    
    // MARK: Initializers
    
    @inlinable init(_ translatables: [String] = [Separator.some.rawValue]) {
        self.translatables = translatables
    }
    
    // MARK: Transformations
    
    @inlinable mutating func insert(_ separators: [String]) {
        translatables.append(contentsOf: separators)
    }
    
    // MARK: Utilities

    @inlinable func parse(_ characters: String, from index: inout String.Index, into storage: inout Separator) {
        let subsequence = characters[index...]
        
        for translatable in translatables {
            guard subsequence.hasPrefix(translatable) else { continue }
            
            storage = .some
            index = subsequence.index(index, offsetBy: translatable.count)
            return
        }
    }
}

// MARK: - NumericTextConfigurationDigits

@usableFromInline struct NumericTextConfigurationDigits {
    @usableFromInline typealias Digits = NumericTextComponents.Digits
    
    // MARK: Properties
    
    @usableFromInline let digits: Set<Character>
    
    // MARK: Initializers
    
    @inlinable init() {
        self.digits = Digits.all
    }
    
    // MARK: Utilities
    
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
    
    // MARK: Options
    
    @usableFromInline static let integer     = Self(rawValue: 1 << 0)
    @usableFromInline static let nonnegative = Self(rawValue: 1 << 1)
    
    // MARK: Properties
    
    @usableFromInline let rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
}
