//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Support

//*============================================================================*
// MARK: * Number
//*============================================================================*

/// A system representation of a number.
///
/// - Integer digits must not be empty.
/// - Integer digits must not contain prefix zeros.
///
@usableFromInline struct Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let zero: Self = {
        var instance = Self(); instance.integer = [.zero]; return instance
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: State
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
    // MARK: Transformations - Precision
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func trim(max: Count) {
        //=--------------------------------------=
        // MARK: Integer
        //=--------------------------------------=
        self.integer .suffix(maxLength: min(max.integer,  max.value))
        self.integer .removeZerosPrefix()
        //=--------------------------------------=
        // MARK: Fraction
        //=--------------------------------------=
        self.fraction.prefix(maxLength: min(max.fraction, max.value - integer.count))
        self.fraction.removeZerosSuffix()
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        self.removeSeparatorAsSuffix()
        self.integer.makeItAtLeastZero()
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations - Separator
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func removeSeparatorAsSuffix() {
        if fraction.digits.isEmpty { separator = nil }
    }
    
    @inlinable mutating func removeImpossibleSeparator(capacity: Count) {
        guard capacity.fraction <= 0 || capacity.value <= 0 else { return }
        self.removeSeparatorAsSuffix()
    }
}

//=----------------------------------------------------------------------------=
// MARK: Number - Count
//=----------------------------------------------------------------------------=

extension Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Integer, Fraction, Value
    //=------------------------------------------------------------------------=
    
    @inlinable func count() -> Count {
        let value = integer.count + fraction.count - integer.count(prefix: \.isZero)
        return Count(value: value, integer: integer.count, fraction: fraction.count)
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
        // MARK: Finalize
        //=--------------------------------------=
        self.integer.removeZerosPrefix()
        self.integer.makeItAtLeastZero()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    #warning("This crashes when String(describing: value) returns scientific notation: 9e-8, for example.")
    /// Requires description to be a standard (non-scientific) representation of a number.
    @inlinable init<T: Value>(_ value: T) throws {
        let characters = String(describing: value)
        try self.init(characters: characters, integer: T.isInteger, unsigned: T.isUnsigned,
        signs: Sign.system, digits: Digit.system, separators: Separator.system)
    }
}
