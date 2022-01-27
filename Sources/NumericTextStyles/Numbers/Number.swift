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
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    /// Parses the value represented by a snapshot.
    ///
    /// To use this method, all formatting characters must be marked as such.
    ///
    @inlinable init(snapshot: Snapshot, integer: Bool, unsigned: Bool,
        signs: [Character: Sign], digits: [Character: Digit], separators: [Character: Separator]) throws {
        var nonvirtuals = snapshot.lazy.filter(\.nonvirtual).makeIterator(); var next = nonvirtuals.next()
        //=--------------------------------------=
        // MARK: Attempt
        //=--------------------------------------=
        attempt: do {
            //=----------------------------------=
            // MARK: Sign
            //=----------------------------------=
            if let character = next, !unsigned, let sign = signs[character] {
                self.sign = sign
                next = nonvirtuals.next()
            }
            //=----------------------------------=
            // MARK: Digits
            //=----------------------------------=
            while let character = next, let digit = digits[character] {
                self.integer.append(digit)
                next = nonvirtuals.next()
            }
            
            guard !integer else { break attempt }
            //=----------------------------------=
            // MARK: Separator
            //=----------------------------------=
            if let character = next, let separator = separators[character], separator == .fraction {
                self.separator = separator
                next = nonvirtuals.next()
            }
            
            guard self.separator != nil else { break attempt }
            //=----------------------------------=
            // MARK: Fraction
            //=----------------------------------=
            while let character = next, let digit = digits[symbol.character] {
                self.fraction.append(digit)
                next = nonvirtuals.next()
            }
        }
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        guard next == nil else {
            throw Info(["unable to parse number in", .mark(snapshot.characters)])
        }
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        self.integer.removeZerosPrefix()
        self.integer.makeItAtLeastZero()
    }
}
