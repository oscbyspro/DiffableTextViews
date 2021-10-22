//
//  NumericTextComponents.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

// MARK: - NumericTextComponents

public struct NumericTextComponents {
    @usableFromInline typealias Style = NumericTextComponentsStyle
    
    // MARK: Properties

    public var sign: Sign = .none
    public var integers = Digits()
    public var separator: Separator = .none
    public var decimals = Digits()
    
    // MARK: Utilities
    
    @inlinable public func characters() -> String {
        sign.rawValue + integers.characters + separator.rawValue + decimals.characters
    }
    
    // MARK: Transformations
    
    @inlinable mutating public func toggleSign(with proposal: Sign) {
        if sign != proposal { sign = proposal } else { sign = .none }
    }
    
    // MARK: Components: Sign
    
    @frozen public enum Sign: String {
        @usableFromInline static let all = Set<Character>("+-")
        
        case positive = "+"
        case negative = "-"
        case none = ""
    }
    
    // MARK: Components: Separator
    
    @frozen public enum Separator: String {
        case some = "."
        case none = ""
    }
    
    // MARK: Components: Digits
    
    @frozen public struct Digits {
        @usableFromInline static let zero: String = "0"
        @usableFromInline static let all = Set<Character>("0123456789")
        
        // MARK: Properties
        
        @usableFromInline var count: Int = 0
        @usableFromInline var characters: String = ""
        
        // MARK: Initializers
        
        @inlinable init() { }
        
        // MARK: Utilities
        
        @inlinable var isEmpty: Bool {
            characters.isEmpty
        }
        
        @inlinable mutating func append(_ character: Character) {
            count += 1
            characters.append(character)
        }
    }
}

extension NumericTextComponents {
    
    // MARK: Initializers
    
    @inlinable init?(_ characters: String, style: Style = Style()) {
        var index = characters.startIndex
        
        // --------------------------------- //
        
        func done() -> Bool {
            index == characters.endIndex
        }
        
        // --------------------------------- //
        
        style.signs.parse(characters, from: &index, into: &sign)
        
        if style.options.contains(.nonnegative) {
            guard sign != .negative else { return nil }
        }
        
        // --------------------------------- //
        
        style.digits.parse(characters, from: &index, into: &integers)
        
        if style.options.contains(.integer) {
            guard done() else { return nil }
            return
        }
        
        // --------------------------------- //
        
        style.separators.parse(characters, from: &index, into: &separator)
        
        if separator == .none {
            guard done() else { return nil }
            return
        }
        
        // --------------------------------- //

        style.digits.parse(characters, from: &index, into: &decimals)
        
        if decimals.isEmpty {
            guard done() else { return nil }
            return
        }
        
        // --------------------------------- //
                
        guard done() else { return nil }
    }
}

// MARK: - NumericTextComponentsConfiguration

@usableFromInline final class NumericTextComponentsStyle {
    @usableFromInline typealias Components = NumericTextComponents
    @usableFromInline typealias Signs = NumericTextComponentsStyleSigns
    @usableFromInline typealias Digits = NumericTextComponentsStyleDigits
    @usableFromInline typealias Separators = NumericTextComponentsStyleSeparators
    @usableFromInline typealias Options = NumericTextComponentsStyleOptions
    
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

// MARK: - NumericTextComponentsSigns

@usableFromInline struct NumericTextComponentsStyleSigns {
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

// MARK: - NumericTextComponentsSeparators

@usableFromInline struct NumericTextComponentsStyleSeparators {
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

// MARK: - NumericTextComponentsDigits

@usableFromInline struct NumericTextComponentsStyleDigits {
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

// MARK: - NumericTextComponentsOptions

@usableFromInline struct NumericTextComponentsStyleOptions: OptionSet {
    
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
