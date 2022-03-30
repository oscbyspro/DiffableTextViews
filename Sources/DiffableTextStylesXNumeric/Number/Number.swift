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
    @usableFromInline typealias Map<Component> = [Character: Component]
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline var sign = Sign.positive
    @usableFromInline private(set) var integer = Digits()
    @usableFromInline private(set) var separator = Separator?.none
    @usableFromInline private(set) var fraction = Digits()
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var rawValue: [UInt8] {
        var rawValue = [UInt8]()
        //=--------------------------------------=
        // MARK: Size
        //=--------------------------------------=
        rawValue.reserveCapacity(
        integer.count + fraction.count + 2)
        //=--------------------------------------=
        // MARK: Sign, Integer
        //=--------------------------------------=
        rawValue.append(sign.rawValue)
        rawValue.append(contentsOf: integer.rawValue)
        //=--------------------------------------=
        // MARK: Separator, Fraction
        //=--------------------------------------=
        if let separator = separator {
            rawValue.append(separator.rawValue)
            rawValue.append(contentsOf: fraction.rawValue)
        }
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return rawValue
    }
    
    @inlinable var hasSeparatorAsSuffix: Bool {
        fraction.digits.isEmpty && separator != nil
    }
    
    @inlinable func count() -> Count {
        let value = integer.count + fraction.count - integer.count(prefix: \.isZero)
        return Count(value: value, integer: integer.count, fraction: fraction.count)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func trim(max: Count) {
        //=--------------------------------------=
        // MARK: Integer
        //=--------------------------------------=
        self.integer.resize(suffix: min(max.integer, max.value))
        self.integer.removeZerosAsPrefix()
        //=--------------------------------------=
        // MARK: Fraction
        //=--------------------------------------=
        self.fraction.resize(prefix: min(max.fraction, max.value - integer.count))
        self.fraction.removeZerosAsSuffix()
        //=--------------------------------------=
        // MARK: Finalize
        //=--------------------------------------=
        self.integer.makeAtLeastZero()
        self.removeSeparatorAsSuffix()
    }
    
    /// Returns true if a suffixing separator was removed, returns false otherwise.
    @inlinable @discardableResult mutating func removeSeparatorAsSuffix() -> Bool {
        if hasSeparatorAsSuffix { separator = nil; return true }; return false
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Parse
//=----------------------------------------------------------------------------=

extension Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    /// Parses the value represented by an **unformatted** sequence.
    @inlinable init<S>(characters: S, integer: Bool, unsigned: Bool,
    signs: Map<Sign>, digits: Map<Digit>, separators: Map<Separator>)
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
            // MARK: Integer
            //=----------------------------------=
            while let character = next, let digit = digits[character] {
                self.integer.append(digit); next = iterator.next()
            }
            //=----------------------------------=
            // MARK: Break
            //=----------------------------------=
            guard !integer else { break body }
            //=----------------------------------=
            // MARK: Separator
            //=----------------------------------=
            if let character = next, let separator = separators[character], separator == .fraction {
                self.separator = separator; next = iterator.next()
            }
            //=----------------------------------=
            // MARK: Break
            //=----------------------------------=
            guard separator != nil else { break body }
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
        self.integer.removeZerosAsPrefix(); self.integer.makeAtLeastZero()
    }
}
