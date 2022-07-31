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
/// - It MUST NOT contain fraction digits without a fraction separator.
///
@usableFromInline struct Number: Tokens {
    
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
        // Transformations
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
            
            if integer { break body }
            //=----------------------------------=
            // Separator
            //=----------------------------------=
            if let character = next, let separator = separators[character], separator == .fraction {
                self.separator = separator; next = iterator.next()
            }
            
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
        self.integer.count == 0,
        self.separator == nil,
        self.fraction.count == 0 {
            return nil
        }
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        self.integer.trim(prefix:{ $0 == .zero })
        self.integer.atLeastZero()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var ascii: [UInt8] {
        let size = integer.count+fraction.count+2
        return Array<UInt8>.init(capacity: size){
        $0.append(sign.ascii)
        $0.append(contentsOf: integer.ascii)
        guard let separator else { return }
        $0.append(separator.ascii)
        $0.append(contentsOf: fraction.ascii)}
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func trim(to precision: Count) -> Bool {
        let trimmed: (integer: Bool,  fraction:  Bool)
        //=--------------------------------------=
        // Trim
        //=--------------------------------------=
        trimmed.integer = self.integer.resize(
        suffix: min(precision.integer,  precision.digits))
        
        trimmed.fraction = self.fraction.resize(
        prefix: min(precision.fraction, precision.digits - integer.count))
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        if  trimmed.integer {
            self.integer.trim(prefix:{ $0 == .zero })
            self.integer.atLeastZero()
        }
        
        if  trimmed.fraction {
            self.fraction.trim(suffix:{ $0 == .zero })
            self.removeSeparatorAsSuffix()
        }
        //=--------------------------------------=
        // Done
        //=--------------------------------------=
        return trimmed.integer || trimmed.fraction
    }
    
    @inlinable @discardableResult mutating func removeSeparatorAsSuffix() -> Bool {
        let remove = fraction.count == 0 && separator != nil
        if  remove { separator = nil }; return remove
    }
}
