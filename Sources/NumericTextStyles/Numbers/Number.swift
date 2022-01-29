//
//  Number.swift
//
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import DiffableTextViews
import Support

//*============================================================================*
// MARK: * Number
//*============================================================================*

/// A system representation of a number.
@usableFromInline struct Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let zero: Self = {
        var instance = Self(); instance.integer = [.zero]; return instance
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline var sign = Sign.positive
    @usableFromInline private(set) var integer   = Digits()
    @usableFromInline private(set) var separator = Separator?.none
    @usableFromInline private(set) var fraction  = Digits()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
    
    @inlinable func count() -> Count {
        //=--------------------------------------=
        // MARK: Integer, Fraction
        //=--------------------------------------=
        let integer  = self.integer .count
        let fraction = self.fraction.count
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let upper = integer  - self.integer .prefixZerosCount()
        var lower = fraction - self.fraction.suffixZerosCount()
        //=--------------------------------------=
        // MARK: Value - Integer Is Zero
        //=--------------------------------------=
        if upper == 0, lower != 0 {
            lower = lower - self.fraction.prefixZerosCount()
        }
        //=--------------------------------------=
        // MARK: Count
        //=--------------------------------------=
        return Count(value: upper + lower, integer: integer, fraction: fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func removeImpossibleSeparator(capacity: Count) {
        guard fraction.digits.isEmpty else { return }
        guard capacity.fraction <= 0 || capacity.value <= 0 else { return }
        separator = nil
    }
}

//=----------------------------------------------------------------------------=
// MARK: Number - Parse
//=----------------------------------------------------------------------------=

extension Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Sequence
    //=------------------------------------------------------------------------=
    
    /// Parses the value represented by an **unformatted** sequence.
    ///
    /// To use this method, all formatting characters must be marked as such.
    ///
    @inlinable init<S: Sequence>(characters: S, integer: Bool, unsigned: Bool,
        signs: [Character: Sign], digits: [Character: Digit], separators: [Character: Separator])
        throws where S.Element == Character {
        var iterator = characters.makeIterator(); var next = iterator.next()
        //=--------------------------------------=
        // MARK: Attempt
        //=--------------------------------------=
        attempt: do {
            //=----------------------------------=
            // MARK: Sign
            //=----------------------------------=
            if !unsigned, let character = next, let sign = signs[character] {
                self.sign = sign
                next = iterator.next()
            }
            //=----------------------------------=
            // MARK: Digits
            //=----------------------------------=
            while let character = next, let digit = digits[character] {
                self.integer.append(digit)
                next = iterator.next()
            }
            
            guard !integer else { break attempt }
            //=----------------------------------=
            // MARK: Separator
            //=----------------------------------=
            if let character = next, let separator = separators[character], separator == .fraction {
                self.separator = separator
                next = iterator.next()
            }
            
            guard self.separator != nil else { break attempt }
            //=----------------------------------=
            // MARK: Fraction
            //=----------------------------------=
            while let character = next, let digit = digits[character] {
                self.fraction.append(digit)
                next = iterator.next()
            }
        }
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        guard next == nil else {
            throw Info(["unable to parse number in", .mark(String(characters))])
        }
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        self.integer.removeZerosPrefix()
        self.integer.makeItAtLeastZero()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: System
    //=------------------------------------------------------------------------=
    
    @inlinable init<T: Value>(_ value: T) throws {
        let characters = String(describing: value)
        try self.init(characters: characters, integer: T.isInteger, unsigned: T.isUnsigned,
        signs: Sign.characters, digits: Digit.characters, separators: Separator.characters)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Number - CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Number: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @usableFromInline var description: String {
        var description = String()
        sign.character.write(to: &description)
        description += integer.digits.map(\.character)
        separator?.character.write(to: &description)
        description += fraction.digits.map(\.character)
        return description
    }
}
