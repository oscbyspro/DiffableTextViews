//
//  Number.swift
//
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import DiffableTextViews

#warning("Rename as Components, maybe.")

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

#warning("Move this to region.")

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
        #warning("Make nonformatting shorter to use, maybe.")
        guard let start = snapshot.firstIndex(where: { !$0.attribute.contains(.formatting) }) else { self = .zero; return }
        
        //=--------------------------------------=
        // MARK: State
        //=--------------------------------------=
        
        var index = start
        var element = snapshot[start]
        
        //=--------------------------------------=
        // MARK: Helpers
        //=--------------------------------------=

        func next() {
            while true {
                snapshot.formIndex(after: &index)
                if index == snapshot.endIndex { break }
                element = snapshot[index]
                if !element.attribute.contains(.formatting) { break }
            }
        }
        
        attempt: do {

            //=----------------------------------=
            // MARK: Sign
            //=----------------------------------=

            if index != snapshot.endIndex, !unsigned, let sign = signs[element.character] {
                self.sign = sign
                next()
            }

            //=----------------------------------=
            // MARK: Digits
            //=----------------------------------=

            while index != snapshot.endIndex, let digit = digits[element.character] {
                self.integer.append(digit)
                next()
            }
            
            self.integer.removeZerosPrefix()
            self.integer.makeItAtLeastZero()
            
            guard !integer else { break attempt }
            
            //=----------------------------------=
            // MARK: Separator
            //=----------------------------------=

            if index != snapshot.endIndex, let _ = separators[element.character] {
                self.separator = .fraction
                next()
            }
            
            guard self.separator == .fraction else { break attempt }
            
            //=----------------------------------=
            // MARK: Fraction
            //=----------------------------------=
            
            while index != snapshot.endIndex, let digit = digits[element.character] {
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
