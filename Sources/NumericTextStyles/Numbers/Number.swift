//
//  Number.swift
//
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import DiffableTextViews

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
        let  integer = self .integer.count
        let fraction = self.fraction.count

        let upper =  integer - self .integer.prefixZerosCount()
        var lower = fraction - self.fraction.suffixZerosCount()
        
        if upper == 0, lower != 0 {
            lower = lower - self.fraction.prefixZerosCount()
        }
        
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
    /// To use this method, all formatting characters must be marked as formatting.
    ///
    @inlinable init(
        snapshot: Snapshot, integer: Bool, unsigned: Bool,
        signs: [Character: Sign], digits: [Character: Digit], separators: [Character: Separator]
    ) throws {
        guard let start = snapshot.firstIndex(where: { !$0.contains(.virtual) }) else { self = .zero; return }
        //=--------------------------------------=
        // MARK: State
        //=--------------------------------------=
        var index = start
        var symbol = snapshot[start]
        //=--------------------------------------=
        // MARK: Next
        //=--------------------------------------=
        func next() {
            //=----------------------------------=
            // MARK: Loop Past Virtual Elements
            //=----------------------------------=
            while true {
                //=------------------------------=
                // MARK: Index
                //=------------------------------=
                snapshot.formIndex(after: &index)
                if index == snapshot.endIndex { break }
                //=------------------------------=
                // MARK: Element
                //=------------------------------=
                symbol = snapshot[index]
                if !symbol.contains(.virtual) { break }
            }
        }
        //=--------------------------------------=
        // MARK: Attempt
        //=--------------------------------------=
        attempt: do {
            //=----------------------------------=
            // MARK: Sign
            //=----------------------------------=
            if index != snapshot.endIndex, !unsigned, let sign = signs[symbol.character] {
                self.sign = sign
                next()
            }
            //=----------------------------------=
            // MARK: Digits
            //=----------------------------------=
            while index != snapshot.endIndex, let digit = digits[symbol.character] {
                self.integer.append(digit)
                next()
            }
            self.integer.removeZerosPrefix()
            self.integer.makeItAtLeastZero()
            
            guard !integer else { break attempt }
            //=----------------------------------=
            // MARK: Separator
            //=----------------------------------=
            if index != snapshot.endIndex, let separator = separators[symbol.character], separator == .fraction {
                self.separator = separator
                next()
            }
            
            guard self.separator != nil else { break attempt }
            //=----------------------------------=
            // MARK: Fraction
            //=----------------------------------=
            while index != snapshot.endIndex, let digit = digits[symbol.character] {
                self.fraction.append(digit)
                next()
            }
        }
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        guard index == snapshot.endIndex else {
            throw Info(["unable to parse number in", .mark(snapshot.characters)])
        }
    }
}
