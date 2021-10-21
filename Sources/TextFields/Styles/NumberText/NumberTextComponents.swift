//
//  NumberTextComponents.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

// MARK: - NumberTextComponents

public struct NumberTextComponents {
    @usableFromInline typealias Configuration = NumberTextComponentsConfiguration
    
    // MARK: Properties

    public var sign = String()
    public var integerDigits = String()
    public var decimalSeparator = String()
    public var decimalDigits = String()
    
    @usableFromInline var configuration: Configuration
    
    // MARK: Initializers
    
    @inlinable init?(_ characters: String, with configuration: Configuration = Configuration()) {
        
        // --------------------------------- //
        
        self.configuration = configuration
        
        // --------------------------------- //
        
        var index = characters.startIndex
        
        // --------------------------------- //
        
        func done() -> Bool {
            index == characters.endIndex
        }
        
        // --------------------------------- //
                
        configuration.signs.parse(characters, from: &index, into: &sign)
        
        if configuration.options.contains(.nonnegative) {
            guard sign != Configuration.Signs.minus else { return nil }
        }
        
        // --------------------------------- //
        
        configuration.digits.parse(characters, from: &index, into: &integerDigits)
        
        if configuration.options.contains(.integer) {
            guard done() else { return nil }
            return
        }
        
        // --------------------------------- //
        
        configuration.separators.parse(characters, from: &index, into: &decimalSeparator)
        
        if decimalSeparator.isEmpty {
            guard done() else { return nil }
            return
        }
        
        // --------------------------------- //

        configuration.digits.parse(characters, from: &index, into: &decimalDigits)
        
        if decimalDigits.isEmpty {
            guard done() else { return nil }
            return
        }
        
        // --------------------------------- //
                
        guard done() else { return nil }

        // --------------------------------- //
    }
    
    // MARK: Transformations

    @inlinable mutating func toggle(sign newValue: String) {
        if configuration.options.contains(.nonnegative), newValue == Configuration.Signs.minus { return }
        
        if sign == newValue { sign = String() }
        else                { sign = newValue }
    }
    
    // MARK: Utilities
    
    @inlinable public func characters() -> String {
        sign + integerDigits + decimalSeparator + decimalDigits
    }
}

// MARK: - NumberTextComponentsConfiguration

@usableFromInline final class NumberTextComponentsConfiguration {
    @usableFromInline typealias Signs = NumberTextComponentsSigns
    @usableFromInline typealias Digits = NumberTextComponentsDigits
    @usableFromInline typealias Separators = NumberTextComponentsSeparators
    @usableFromInline typealias Options = NumberTextComponentsOptions
    
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

// MARK: - NumberTextComponentsSigns

@usableFromInline struct NumberTextComponentsSigns {

    // MARK: Statics
    
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
    
    // MARK: Initializers: Static
    
    @inlinable static var none: Self {
        .init(positives: [], negatives: [])
    }
    
    @inlinable static var positive: Self {
        .init(positives: [plus], negatives: [])
    }
    
    @inlinable static var negative: Self {
        .init(positives: [], negatives: [minus])
    }
    
    @inlinable static var all: Self {
        .init(positives: [plus], negatives: [minus])
    }
    
    // MARK: Transformations
    
    @inlinable mutating func remove(all signs: Denomination) {
        switch signs {
        case .positive: positives.removeAll()
        case .negative: negatives.removeAll()
        }
    }
    
    // MARK: Utilities
    
    @inlinable func contains(_ sign: String) -> Bool {
        negatives.contains(sign) || positives.contains(sign)
    }
    
    // MARK: Parses
    
    @inlinable func parse(_ characters: String, from index: inout String.Index, into storage: inout String) {
        let subsequence = characters[index...]
                
        func parse(_ signs: [String], success: String) -> Bool {
            for sign in signs {
                guard subsequence.hasPrefix(sign) else { continue }
                
                storage = success
                index = subsequence.index(index, offsetBy: sign.count)
                return true
            }
            
            return false
        }
        
        guard !parse(negatives, success: Self.minus) else { return }
        guard !parse(positives, success: Self.plus) else { return }
    }
    
    // MARK: Denomination
    
    @usableFromInline @frozen enum Denomination { case positive, negative }
}

// MARK: - NumberTextComponentsDigits

@usableFromInline struct NumberTextComponentsDigits {
    
    // MARK: Statics
    
    @inlinable static var zero: String { "0" }
    @usableFromInline static let all = Set<Character>("0123456789")
    
    // MARK: Properties
    
    @usableFromInline let digits: Set<Character>
    
    // MARK: Initializers
    
    @inlinable init() {
        self.digits = Self.all
    }
    
    // MARK: Utilities
    
    @inlinable func parse(_ characters: String, from index: inout String.Index, into storage: inout String) {
        let subsequence = characters[index...]
        
        for character in subsequence {
            guard digits.contains(character) else { break }
            
            storage.append(character)
            index = subsequence.index(after: index)
        }
    }
}

// MARK: - NumberTextComponentsSeparators

@usableFromInline struct NumberTextComponentsSeparators {
    
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
    
    @inlinable mutating func translate(_ separators: [String]) {
        translatables.append(contentsOf: separators)
    }
    
    // MARK: Utilities

    @inlinable func parse(_ characters: String, from index: inout String.Index, into storage: inout String) {
        let subsequence = characters[index...]
        
        for translatable in translatables {
            guard subsequence.hasPrefix(translatable) else { continue }
            
            storage = Self.separator
            index = subsequence.index(index, offsetBy: translatable.count)
            break
        }
    }
}

// MARK: - NumberTextComponentsOptions

@usableFromInline struct NumberTextComponentsOptions: OptionSet {
    
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
