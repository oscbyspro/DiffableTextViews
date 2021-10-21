//
//  NumberTextComponents.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

// MARK: - NumberTextComponents

public struct NumberTextComponents {
    @usableFromInline typealias Options = NumberTextComponentsOptions
    @usableFromInline typealias Separators = NumberTextComponentsSeparators
    @usableFromInline typealias Constants = NumberTextComponentsConstants
    
    // MARK: Properties

    public var sign = String()
    public var integerDigits = String()
    public var decimalSeparator = String()
    public var decimalDigits = String()
    
    // MARK: Initializers
    
    @inlinable init?(_ characters: String, separators: Separators = Separators(), options: Options = Options()) {

        // --------------------------------- //
        
        var index = characters.startIndex
        
        // --------------------------------- //

        Self.parse(
            prefix: Constants.minus,
            in: characters,
            from: &index,
            into: &sign)

        if options.contains(.nonnegative) {
            guard sign.isEmpty else { return nil }
        }
        
        // --------------------------------- //
        
        Self.parse(
            charactersIn: Constants.digits,
            in: characters,
            from: &index,
            into: &integerDigits)
        
        if options.contains(.integer) {
            guard characters[index...].isEmpty else { return nil }
            return
        }
        
        // --------------------------------- //
        
        separators.parse(
            characters,
            from: &index,
            into: &decimalSeparator)

        // --------------------------------- //

        Self.parse(
            charactersIn: Constants.digits,
            in: characters,
            from: &index,
            into: &decimalDigits)
    
        // --------------------------------- //
        
        guard characters[index...].isEmpty else { return nil }
        
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

extension NumberTextComponents {
    
    // MARK: Helpers: Static
    
    @inlinable static func parse(prefix: String, in characters: String, from index: inout String.Index, into storage: inout String) {
        if characters[index...].hasPrefix(prefix) {
            storage.append(prefix)
            index = characters.index(index, offsetBy: prefix.count)
        }
    }

    @inlinable static func parse(charactersIn set: Set<Character>, in characters: String, from index: inout String.Index, into storage: inout String) {
        for character in characters[index...] {
            guard set.contains(character) else { break }
            
            storage.append(character)
            index = characters.index(after: index)
        }
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

// MARK: - NumberTextComponentsSeparators

@usableFromInline struct NumberTextComponentsSeparators {
    
    // MARK: Properties: Static
    
    @inlinable static var system: String {
        NumberTextComponentsConstants.separator
    }
        
    // MARK: Properties
    
    @usableFromInline var translatables: [String]
    
    // MARK: Initializers
    
    @inlinable init(separators: [String] = []) {
        self.translatables = separators
        self.translatables.append(Self.system)
    }
    
    // MARK: Initializers: Static
    
    @inlinable static func translates(_ separators: [String]) -> Self {
        .init(separators: separators)
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
        var copy = self
        
        if predicate {
            copy.insert(element)
        }
        
        return copy
    }
}
