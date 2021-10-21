//
//  NumberTextComponents.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

// MARK: - NumberTextComponents

public struct NumberTextComponents {
    @usableFromInline typealias Constants = NumberTextComponentsConstants
    @usableFromInline typealias Signs = NumberTextComponentsSigns
    @usableFromInline typealias Digits = NumberTextComponentsDigits
    @usableFromInline typealias Separators = NumberTextComponentsSeparators
    @usableFromInline typealias Options = NumberTextComponentsOptions
    
    // MARK: Properties

    public var sign = String()
    public var integerDigits = String()
    public var decimalSeparator = String()
    public var decimalDigits = String()
    
    // MARK: Initializers
    
    @inlinable init?(_ characters: String, signs: Signs = Signs(), digits: Digits = Digits(), separators: Separators = Separators(), options: Options = Options()) {

        // --------------------------------- //
        
        var index = characters.startIndex
        
        // --------------------------------- //
        
        func done() -> Bool {
            characters[index...].isEmpty
        }
        
        // --------------------------------- //
        
        signs.parse(characters, from: &index, into: &sign)
        
        if options.contains(.nonnegative) {
            guard sign != Constants.minus else { return nil }
        }
        
        // --------------------------------- //
        
        digits.parse(characters, from: &index, into: &integerDigits)
        
        if options.contains(.integer) {
            guard done() else { return nil }
            return
        }
        
        // --------------------------------- //
        
        separators.parse(characters, from: &index, into: &decimalSeparator)

        // --------------------------------- //

        digits.parse(characters, from: &index, into: &decimalDigits)
    
        // --------------------------------- //
        
        guard done() else { return nil }
        
        // --------------------------------- //
    }
    
    // MARK: Descriptions

    @inlinable public var isEmpty: Bool {
        sign.isEmpty && integerDigits.isEmpty && decimalSeparator.isEmpty && decimalDigits.isEmpty
    }
    
    @inlinable public var digitsAreEmpty: Bool {
        integerDigits.isEmpty && decimalDigits.isEmpty
    }
    
    // MARK: Transformations
    
    @inlinable mutating func toggleSign() {
        sign = sign.isEmpty ? Constants.minus : String()
    }
    
    // MARK: Utilities
    
    @inlinable public func characters() -> String {
        sign + integerDigits + decimalSeparator + decimalDigits
    }
}

// MARK: - NumberTextComponentsConstants

@usableFromInline enum NumberTextComponentsConstants {
    
    // MARK: Properties: Static
    
    @usableFromInline static let minus: String = "-"
    @usableFromInline static let separator: String = "."
    @usableFromInline static let zero: String = "0"
    @usableFromInline static let digits = Set<Character>("0123456789")
}

// MARK: - NumberTextComponentsSigns

@usableFromInline struct NumberTextComponentsSigns {
    
    // MARK: Properties: Static
    
    @inlinable static var minus: String {
        NumberTextComponentsConstants.minus
    }
    
    // MARK: Properties
    
    @usableFromInline var minuses: [String]
    
    // MARK: Initializers
    
    @inlinable init(minuses: [String] = []) {
        self.minuses = minuses
        self.minuses.append(Self.minus)
    }
    
    // MARK: Utilities
    
    @inlinable func parse(_ characters: String, from index: inout String.Index, into storage: inout String) {
        let subsequence = characters[index...]
        
        for element in minuses {
            guard subsequence.hasPrefix(element) else { continue }
            
            storage = Self.minus
            index = subsequence.index(index, offsetBy: element.count)
            break
        }
    }
}

// MARK: - NumberTextComponentsDigits

@usableFromInline struct NumberTextComponentsDigits {
    
    // MARK: Properties
    
    @inlinable var digits: Set<Character> {
        NumberTextComponentsConstants.digits
    }
    
    // MARK: Initializers
    
    @inlinable init() { }
    
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
    
    // MARK: Properties: Static
    
    @inlinable static var system: String {
        NumberTextComponentsConstants.separator
    }
        
    // MARK: Properties

    @usableFromInline var translatables: [String]
    
    // MARK: Initializers
    
    @inlinable init(translatables: [String] = []) {
        self.translatables = translatables
        self.translatables.append(Self.system)
    }
    
    // MARK: Initializers: Static
    
    @inlinable static func translates(_ separators: [String]) -> Self {
        .init(translatables: separators)
    }
    
    // MARK: Utilities

    @inlinable func parse(_ characters: String, from index: inout String.Index, into storage: inout String) {
        let subsequence = characters[index...]
        
        for element in translatables {
            guard subsequence.hasPrefix(element) else { continue }
            
            storage = Self.system
            index = subsequence.index(index, offsetBy: element.count)
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
    
    @inlinable public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    // MARK: Tansformations
    
    @inlinable public func insert(_ element: Self, when predicate: Bool) -> Self {
        var copy = self; if predicate { copy.insert(element) }; return copy
    }
}
