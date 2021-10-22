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
    public var integers = String()
    public var separator: Separator = .none
    public var decimals = String()
    
    // MARK: Utilities
    
    @inlinable public func characters() -> String {
        sign.rawValue + integers + separator.rawValue + decimals
    }
    
    // MARK: Transformations
    
    @inlinable mutating public func toggleSign(with proposal: Sign) {
        if sign != proposal { sign = proposal } else { sign = .none }
    }
    
    // MARK: Components
    
    @frozen public enum Sign: String {
        case positive = "+"
        case negative = "-"
        case none = ""
    }
    
    @frozen public enum Separator: String {
        case some = "."
        case none = ""
    }
}

extension NumericTextComponents {
    
    // MARK: Initializers
    
    @inlinable init?(_ characters: String, style: Style = Style()) {
        
        // --------------------------------- //
        
        var index = characters.startIndex
        
        // --------------------------------- //
        
        func done() -> Bool {
            index == characters.endIndex
        }
        
        // --------------------------------- //
        
        self.sign = style.signs.parse(characters, from: &index)
        
        if style.options.contains(.nonnegative) {
            guard sign != .negative else { return nil }
        }
        
        // --------------------------------- //
        
        self.integers = style.digits.parse(characters, from: &index)
        
        if style.options.contains(.integer) {
            guard done() else { return nil }
            return
        }
        
        // --------------------------------- //
        
        self.separator = style.separators.parse(characters, from: &index)
        
        if separator == .none {
            guard done() else { return nil }
            return
        }
        
        // --------------------------------- //

        self.decimals = style.digits.parse(characters, from: &index)
        
        if decimals.isEmpty {
            guard done() else { return nil }
            return
        }
        
        // --------------------------------- //
                
        guard done() else { return nil }

        // --------------------------------- //
    }
}

// MARK: - NumericTextComponentsConfiguration

@usableFromInline final class NumericTextComponentsStyle {
    @usableFromInline typealias Components = NumericTextComponents
    @usableFromInline typealias Signs = NumericTextComponentsSigns
    @usableFromInline typealias Digits = NumericTextComponentsDigits
    @usableFromInline typealias Separators = NumericTextComponentsSeparators
    @usableFromInline typealias Options = NumericTextComponentsOptions
    
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

@usableFromInline struct NumericTextComponentsSigns {
    @usableFromInline typealias Components = NumericTextComponents
    
    // MARK: Statics
    
    #warning("TODO...")
    @inlinable static var plus:  String { "+" }
    @inlinable static var minus: String { "-" }
    @inlinable static var both:  String { plus + minus }
    
    // MARK: Properties
    
    @usableFromInline var positives: [String]
    @usableFromInline var negatives: [String]
    
    // MARK: Initializers
    
    @inlinable init(positives: [String] = [Self.plus], negatives: [String] = [Self.minus]) {
        self.positives = positives
        self.negatives = negatives
    }
    
    // MARK: Utilities
    
    @inlinable func interpret(_ characters: String) -> Components.Sign {
        if positives.contains(characters) { return .positive }
        if negatives.contains(characters) { return .negative }
        return .none
    }
    
    // MARK: Parses
    
    @inlinable func parse(_ characters: String, from index: inout String.Index) -> Components.Sign {
        let subsequence = characters[index...]
                
        func parse(_ signs: [String]) -> Bool {
            for sign in signs {
                guard subsequence.hasPrefix(sign) else { continue }
                
                index = subsequence.index(index, offsetBy: sign.count)
                return true
            }
            
            return false
        }
        
        if parse(negatives) { return .negative }
        if parse(positives) { return .positive }
        
        return .none
    }
}

// MARK: - NumericTextComponentsDigits

@usableFromInline struct NumericTextComponentsDigits {
    
    // MARK: Statics
    
    @usableFromInline static let zero: String = "0"
    @usableFromInline static let all = Set<Character>("0123456789")
    
    // MARK: Properties
    
    @usableFromInline let digits: Set<Character>
    
    // MARK: Initializers
    
    @inlinable init() {
        self.digits = Self.all
    }
    
    // MARK: Utilities
    
    @inlinable func parse(_ characters: String, from index: inout String.Index) -> String {
        let match = characters[index...].prefix(while: digits.contains)
        index = match.endIndex
        return String(match)
    }
}

// MARK: - NumericTextComponentsSeparators

@usableFromInline struct NumericTextComponentsSeparators {
    @usableFromInline typealias Components = NumericTextComponents
    
    // MARK: Statics
    
    @inlinable static var separator: String { "." }
    
    // MARK: Properties

    @usableFromInline var translatables: [String]
    
    // MARK: Initializers
    
    @inlinable init() {
        self.translatables = []
        self.translatables.append(Self.separator)
    }
    
    // MARK: Transformations
    
    @inlinable mutating func insert(_ separators: [String]) {
        translatables.append(contentsOf: separators)
    }
    
    // MARK: Utilities

    @inlinable func parse(_ characters: String, from index: inout String.Index) -> Components.Separator {
        let subsequence = characters[index...]
        
        for translatable in translatables {
            guard subsequence.hasPrefix(translatable) else { continue }
            
            index = subsequence.index(index, offsetBy: translatable.count)
            return .some
        }
        
        return .none
    }
}

// MARK: - NumericTextComponentsOptions

@usableFromInline struct NumericTextComponentsOptions: OptionSet {
    
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
