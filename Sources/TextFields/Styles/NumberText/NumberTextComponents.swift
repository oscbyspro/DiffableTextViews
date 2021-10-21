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
            guard sign != type(of: configuration.signs).minus else { return nil }
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

    @inlinable mutating func toggle(sign denomination: Configuration.Signs.Denomination) {
        if configuration.options.contains(.nonnegative) && denomination == .negative { return }

        // --------------------------------- //
        
        let characters = configuration.signs.make(denomination)
        
        // --------------------------------- //
                
        if sign == characters { sign = String()   }
        else                  { sign = characters }
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
    
    // MARK: Transformations
    
    @inlinable mutating func remove(all denomination: Denomination) {
        switch denomination {
        case .positive: positives.removeAll()
        case .negative: negatives.removeAll()
        }
    }
    
    @inlinable mutating func insert(_ signs: [String], as denomination: Denomination) {
        switch denomination {
        case .positive: positives.append(contentsOf: signs)
        case .negative: negatives.append(contentsOf: signs)
        }
    }
    
    // MARK: Utilities
    
    @inlinable func make(_ denomination: Denomination) -> String {
        switch denomination {
        case .positive: return Self.plus
        case .negative: return Self.minus
        }
    }
    
    @inlinable func interpret(_ characters: String) -> Denomination? {
        if positives.contains(characters) { return .positive }
        if negatives.contains(characters) { return .negative }
        
        return nil
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
    
    @inlinable        static var zero: String { "0" }
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
    
    @inlinable mutating func insert(_ separators: [String]) {
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
