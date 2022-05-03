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
// MARK: Declaration
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
        // Size
        //=--------------------------------------=
        rawValue.reserveCapacity(
        integer.count + fraction.count + 2)
        //=--------------------------------------=
        // Sign, Integer
        //=--------------------------------------=
        rawValue.append(sign.rawValue)
        rawValue.append(contentsOf: integer.rawValue)
        //=--------------------------------------=
        // Separator, Fraction
        //=--------------------------------------=
        if let separator = separator {
            rawValue.append(separator.rawValue)
            rawValue.append(contentsOf: fraction.rawValue)
        }
        //=--------------------------------------=
        // Done
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
        // Integer
        //=--------------------------------------=
        self.integer.resize(suffix: min(max.integer, max.value))
        self.integer.removeZerosAsPrefix()
        //=--------------------------------------=
        // Fraction
        //=--------------------------------------=
        self.fraction.resize(prefix: min(max.fraction, max.value - integer.count))
        self.fraction.removeZerosAsSuffix()
        //=--------------------------------------=
        // Finalize
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
// MARK: Parse
//=----------------------------------------------------------------------------=

extension Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    @inlinable init<S>(unformatted: S, integer: Bool, unsigned: Bool,
    signs: Map<Sign>, digits: Map<Digit>, separators: Map<Separator>)
    throws where S: Sequence, S.Element == Character {
        //=--------------------------------------=
        // State
        //=--------------------------------------=
        var signable = !unsigned
        var iterator = unformatted.makeIterator()
        var next = iterator.next()
        //=--------------------------------------=
        // Utilities
        //=--------------------------------------=
        func sign() {
            if signable, let character = next, let sign = signs[character] {
                self.sign = sign; next = iterator.next(); signable = false
            }
        }
        //=--------------------------------------=
        // Sign: Prefix
        //=--------------------------------------=
        sign()
        //=--------------------------------------=
        // Body
        //=--------------------------------------=
        body: do {
            //=----------------------------------=
            // Integer
            //=----------------------------------=
            while let character = next, let digit = digits[character] {
                self.integer.append(digit); next = iterator.next()
            }
            //=----------------------------------=
            // Break When It Is Not An Integer
            //=----------------------------------=
            guard !integer else { break body }
            //=----------------------------------=
            // Separator
            //=----------------------------------=
            if let character = next, let separator = separators[character], separator == .fraction {
                self.separator = separator; next = iterator.next()
            }
            //=----------------------------------=
            // Break When It Has No Separator
            //=----------------------------------=
            guard separator != nil else { break body }
            //=----------------------------------=
            // Fraction
            //=----------------------------------=
            while let character = next, let digit = digits[character] {
                self.fraction.append(digit); next = iterator.next()
            }
        }
        //=--------------------------------------=
        // Sign: Suffix
        //=--------------------------------------=
        sign()
        //=--------------------------------------=
        // Validate
        //=--------------------------------------=
        guard next == nil else {
            throw Info(["unable to parse number in", .mark(String(unformatted))])
        }
        //=--------------------------------------=
        // Finalize
        //=--------------------------------------=
        self.integer.removeZerosAsPrefix(); self.integer.makeAtLeastZero()
    }
}
