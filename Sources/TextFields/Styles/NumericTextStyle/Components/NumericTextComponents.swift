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
    public var integers: Digits = .init()
    public var separator: Separator = .none
    public var decimals: Digits = .init()
    
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
        @usableFromInline static let all = Set<Character>(positive.rawValue + negative.rawValue)
        
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
        @usableFromInline static let all = Set<Character>(zero + nonzero)
        @inlinable        static var zero:    String { "0" }
        @inlinable        static var nonzero: String { "123456789" }
        
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

// MARK: - Initializers

extension NumericTextComponents {
    
    // MARK: Style
    
    @inlinable init?(_ characters: String, style: Style = Style()) {
        
        // --------------------------------- //
        
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
        
        // --------------------------------- //
    }
}
