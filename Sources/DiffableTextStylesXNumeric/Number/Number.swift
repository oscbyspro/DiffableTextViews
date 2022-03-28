//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Number
//*============================================================================*

/// A compositional model of a number.
///
/// - Its integer digits MUST contain at least one digit.
/// - Its integer digits MUST NOT contain redundant prefix zeros.
/// - It MUST NOT contain fraction digits without containing a fraction separator.
///
@usableFromInline struct Number: Glyphs {
    
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
    @inlinable init<S>(characters: S, integer: Bool, unsigned: Bool,
    signs: [Character: Sign], digits: [Character: Digit], separators: [Character: Separator])
    throws where S: Sequence, S.Element == Character {
        //=--------------------------------------=
        // MARK: State
        //=--------------------------------------=
        var signable = !unsigned
        var iterator = characters.makeIterator()
        var next = iterator.next()
        //=--------------------------------------=
        // MARK: Helpers
        //=--------------------------------------=
        func sign() {
            if signable, let character = next, let sign = signs[character] {
                self.sign = sign; next = iterator.next(); signable = false
            }
        }
        //=--------------------------------------=
        // MARK: Sign - Prefix
        //=--------------------------------------=
        sign()
        //=--------------------------------------=
        // MARK: Body
        //=--------------------------------------=
        body: do {
            //=----------------------------------=
            // MARK: Digits
            //=----------------------------------=
            while let character = next, let digit = digits[character] {
                self.integer.append(digit); next = iterator.next()
            }
            //=----------------------------------=
            // MARK: Break - Integer
            //=----------------------------------=
            guard !integer else { break body }
            //=----------------------------------=
            // MARK: Separator
            //=----------------------------------=
            if let character = next, let separator = separators[character], separator == .fraction {
                self.separator = separator; next = iterator.next()
            }
            //=----------------------------------=
            // MARK: Break - Nonseparated
            //=----------------------------------=
            guard separator == .fraction else { break body }
            //=----------------------------------=
            // MARK: Fraction
            //=----------------------------------=
            while let character = next, let digit = digits[character] {
                self.fraction.append(digit); next = iterator.next()
            }
        }
        //=--------------------------------------=
        // MARK: Sign - Suffix
        //=--------------------------------------=
        sign()
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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func count() -> Count {
        let value = integer.count + fraction.count - integer.count(prefix: \.isZero)
        return Count(value: value, integer: integer.count, fraction: fraction.count)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Separator
    //=------------------------------------------------------------------------=
    
    /// Returns true if a suffixing separator was removed, returns false otherwise.
    @inlinable @discardableResult mutating func removeSeparatorAsSuffix() -> Bool {
        if hasSeparatorAsSuffix { separator = nil; return true }; return false
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func trim(max: Count) {
        //=--------------------------------------=
        // MARK: Integer
        //=--------------------------------------=
        self.integer.suffix(maxLength:  min(max.integer, max.value))
        self.integer.trimZerosPrefix()
        //=--------------------------------------=
        // MARK: Fraction
        //=--------------------------------------=
        self.fraction.prefix(maxLength: min(max.fraction, max.value - integer.count))
        self.fraction.trimZerosSuffix()
        //=--------------------------------------=
        // MARK: Finalize
        //=--------------------------------------=
        self.integer.makeAtLeastZero()
        self.removeSeparatorAsSuffix()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Number {
    
    //=------------------------------------------------------------------------=
    // MARK: ASCII
    //=------------------------------------------------------------------------=
    
    @inlinable var capacity: Int {
        integer.count + fraction.count + (separator != nil ? 2 : 1)
    }
    
    @inlinable func bytes() -> [UInt8] {
        var bytes = [UInt8]()
        bytes.reserveCapacity(capacity)
        //=--------------------------------------=
        // MARK: Integer
        //=--------------------------------------=
        bytes.append(sign.rawValue)
        bytes.append(contentsOf: integer.bytes())
        //=--------------------------------------=
        // MARK: Floating Point
        //=--------------------------------------=
        if let separator = separator {
            bytes.append(separator.rawValue)
            bytes.append(contentsOf: fraction.bytes())
        }
        //=--------------------------------------=
        // MARK: Bytes
        //=--------------------------------------=
        return bytes
    }
}
