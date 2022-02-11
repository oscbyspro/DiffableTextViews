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
/// - Fraction digits must be empty when there is no separator.
///
@usableFromInline struct Number {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline var sign = Sign.positive
    @usableFromInline private(set) var integer = Digits()
    @usableFromInline private(set) var separator = Separator?.none
    @usableFromInline private(set) var fraction = Digits()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
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
                self.sign = sign; next = iterator.next()
            }
            //=----------------------------------=
            // MARK: Digits
            //=----------------------------------=
            while let character = next, let digit = digits[character] {
                self.integer.append(digit); next = iterator.next()
            }
            //=----------------------------------=
            // MARK: Break - Integer
            //=----------------------------------=
            guard !integer else { break attempt }
            //=----------------------------------=
            // MARK: Separator
            //=----------------------------------=
            if let character = next, let _ = separators[character] {
                /// The sequence is unformatted, which means that all separators may be interpreted as fraction separators.
                /// The only time a non-fraction separators should appear is when it is merged as a result of the user's input.
                self.separator = .fraction; next = iterator.next()
            }
            //=----------------------------------=
            // MARK: Break - Nonseparated
            //=----------------------------------=
            guard separator == .fraction else { break attempt }
            //=----------------------------------=
            // MARK: Fraction
            //=----------------------------------=
            while let character = next, let digit = digits[character] {
                self.fraction.append(digit); next = iterator.next()
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
        self.integer.trimZerosPrefix()
        self.integer.makeAtLeastZero()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var hasSeparatorAsSuffix: Bool {
        fraction.digits.isEmpty && separator != nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations - Precision
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func trim(max: Count) {
        //=--------------------------------------=
        // MARK: Integer
        //=--------------------------------------=
        self.integer.suffix(maxLength: min(max.integer,  max.value))
        self.integer.trimZerosPrefix()
        //=--------------------------------------=
        // MARK: Fraction
        //=--------------------------------------=
        self.fraction.prefix(maxLength: min(max.fraction, max.value - integer.count))
        self.fraction.trimZerosSuffix()
        //=--------------------------------------=
        // MARK: Finalize
        //=--------------------------------------=
        self.removeSeparatorAsSuffix()
        self.integer.makeAtLeastZero()
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func count() -> Count {
        let value = integer.count + fraction.count - integer.count(prefix: \.isZero)
        return Count(value: value, integer: integer.count, fraction: fraction.count)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Number - TextOutputStreamable
//=----------------------------------------------------------------------------=

extension Number: TextOutputStreamable {
    
    //=------------------------------------------------------------------------=
    // MARK: Write
    //=------------------------------------------------------------------------=
    
    @inlinable public func write<T: TextOutputStream>(to target: inout T) {
        sign.write(to: &target)
        integer.write(to: &target)
        separator?.write(to: &target)
        fraction.write(to: &target)
    }
}
