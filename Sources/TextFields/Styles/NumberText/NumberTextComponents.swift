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

    public var minus = String()
    public var upper = String()
    public var separator = String()
    public var lower = String()
    
    // MARK: Initializers
    
    @inlinable init?(_ characters: String, separators: Separators = .system, options: Options = Options()) {

        // --------------------------------- //
        
        var index = characters.startIndex
        
        // --------------------------------- //

        Self.parse(prefix: Constants.minus, in: characters, from: &index, into: &minus)

        if options.contains(.nonnegative) {
            guard minus.isEmpty else { return nil }
        }
        
        // --------------------------------- //
        
        Self.parse(charactersIn: Constants.digits, in: characters, from: &index, into: &upper)
        
        if options.contains(.integer) {
            guard characters[index...].isEmpty else { return nil }
            return
        }
        
        // --------------------------------- //
        
        separators.parse(characters, from: &index, into: &separator)

        // --------------------------------- //

        Self.parse(charactersIn: Constants.digits, in: characters, from: &index, into: &lower)
    
        // --------------------------------- //
        
        guard characters[index...].isEmpty else { return nil }
        
        // --------------------------------- //
                
    }
    
    // MARK: Descriptions
    
    @inlinable public var isEmpty: Bool {
        minus.isEmpty && upper.isEmpty && separator.isEmpty && lower.isEmpty
    }
    
    @inlinable public var digitsAreEmpty: Bool {
        upper.isEmpty && lower.isEmpty
    }
        
    // MARK: Transformations
    
    @inlinable mutating func toggleSign() {
        minus = minus.isEmpty ? Constants.minus : String()
    }
    
    // MARK: Utilities
    
    @inlinable public func characters() -> String {
        minus + upper + separator + lower
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
    @usableFromInline typealias Constants = NumberTextComponentsConstants
    
    // MARK: Properties
    
    @usableFromInline var elements: [String]
    
    // MARK: Initializers
    
    @inlinable init(elements: [String] = []) {
        self.elements = elements
        self.elements.append(Constants.separator)
    }
    
    // MARK: Initializers: Static
    
    @inlinable static var system: Self {
        .init()
    }
    
    @inlinable static func translates(_ elements: [String]) -> Self {
        .init(elements: elements)
    }
    
    // MARK: Utilities

    @inlinable func parse(_ characters: String, from index: inout String.Index, into storage: inout String) {
        let subsequence = characters[index...]
        
        for element in elements {
            guard subsequence.hasPrefix(element) else { continue }
            
            storage = Constants.separator
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
