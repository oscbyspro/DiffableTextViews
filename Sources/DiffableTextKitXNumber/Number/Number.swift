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

/// A tokenized number.
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
    
    @inlinable @inline(never) init?(
    unformatted: some Sequence<Character>, signs: [Character: Sign],
    digits: [Character: Digit],  separators: [Character: Separator],
    optional: Bool, unsigned: Bool, integer: Bool) throws {
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
        // Sign As Prefix
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
            // Integer
            //=----------------------------------=
            if integer { break body }
            //=----------------------------------=
            // Separator
            //=----------------------------------=
            if let character = next, let separator = separators[character], separator == .fraction {
                self.separator = separator; next = iterator.next()
            }
            //=----------------------------------=
            // Separator
            //=----------------------------------=
            if separator == nil { break body }
            //=----------------------------------=
            // Fraction
            //=----------------------------------=
            while let character = next, let digit = digits[character] {
                self.fraction.append(digit); next = iterator.next()
            }
        }
        //=--------------------------------------=
        // Sign As Suffix
        //=--------------------------------------=
        sign()
        //=--------------------------------------=
        // Validate
        //=--------------------------------------=
        guard next == nil else {
            throw Info(["unable to parse number in", .mark(String(unformatted))])
        }
        //=--------------------------------------=
        // Optional
        //=--------------------------------------=
        if optional,
        self.integer.digits.isEmpty,
        self.separator == nil,
        self.fraction.digits.isEmpty {
            return nil
        }
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        self.integer.trim(prefix: \.isZero)
        self.integer.replaceEmptyWithZero()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var rawValue: [UInt8] {
        let size = integer.count+fraction.count+2
        return Array<UInt8>.init(capacity: size){
        $0.append(sign.rawValue)
        $0.append(contentsOf: integer.rawValue)
        guard let separator else { return }
        $0.append(separator.rawValue)
        $0.append(contentsOf: fraction.rawValue)}
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
    
    @inlinable @discardableResult mutating func removeSeparatorAsSuffix() -> Bool {
        let remove = hasSeparatorAsSuffix; if remove { separator = nil }; return remove
    }
    
    @inlinable mutating func trim(to precision: Count) -> Bool {
        let trimmed: (integer: Bool,  fraction:  Bool)
        //=--------------------------------------=
        // Trim
        //=--------------------------------------=
        trimmed.integer = self.integer.resize(
        suffix: min(precision.integer,  precision.value))
        
        trimmed.fraction = self.fraction.resize(
        prefix: min(precision.fraction, precision.value - integer.count))
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        if  trimmed.integer {
            self.integer.trim(prefix: \.isZero)
            self.integer.replaceEmptyWithZero()
        }
        
        if  trimmed.fraction {
            self.fraction.trim(suffix:\.isZero)
            self.removeSeparatorAsSuffix()
        }
        //=--------------------------------------=
        // Done
        //=--------------------------------------=
        return trimmed.integer || trimmed.fraction
    }
}
