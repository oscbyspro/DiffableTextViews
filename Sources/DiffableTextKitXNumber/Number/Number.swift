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
        Array(capacity: integer.count + fraction.count + 2) {
            $0.append(sign.rawValue)
            $0.append(contentsOf: integer.rawValue)
            guard let separator = separator else { return }
            $0.append(separator.rawValue)
            $0.append(contentsOf: fraction.rawValue)
        }
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
    
    /// Returns true if a suffixing separator was removed, returns false otherwise.
    @inlinable @discardableResult mutating func removeSeparatorAsSuffix() -> Bool {
        if hasSeparatorAsSuffix { separator = nil; return true }; return false
    }
    
    @inlinable mutating func trimToFit(_ precision: Count) {
        //=--------------------------------------=
        // Integer
        //=--------------------------------------=
        self.integer.resize(suffix: min(precision.integer, precision.value))
        self.integer.removeZerosAsPrefix()
        //=--------------------------------------=
        // Fraction
        //=--------------------------------------=
        self.fraction.resize(prefix: min(precision.fraction, precision.value - integer.count))
        self.fraction.removeZerosAsSuffix()
        //=--------------------------------------=
        // Finalize
        //=--------------------------------------=
        self.integer.makeAtLeastZero()
        self.removeSeparatorAsSuffix()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Parse
//=----------------------------------------------------------------------------=

extension Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    /// Requires that all formatting characters are marked as virtual.
    @inlinable init?<T>(in snapshot: Snapshot,
    using components: Components, as kind: T.Type)
    throws where T: NumberTextKind {
        let unformatted = snapshot.lazy.filter(\.nonvirtual).map(\.character)
        try self.init(unformatted: unformatted,
        signs: components.signs.components,
        digits: components.digits.components,
        separators: components.separators.components,
        optional: kind.isOptional,
        unsigned: kind.isUnsigned,
        integer:  kind.isInteger )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    @usableFromInline init?<S>(unformatted sequence: S,
    signs: Map<Sign>, digits: Map<Digit>, separators: Map<Separator>,
    optional: Bool, unsigned: Bool, integer: Bool)
    throws where S: Sequence, S.Element == Character {
        //=--------------------------------------=
        // State
        //=--------------------------------------=
        var signable = !unsigned
        var iterator = sequence.makeIterator()
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
        // Sign: Suffix
        //=--------------------------------------=
        sign()
        //=--------------------------------------=
        // Validate
        //=--------------------------------------=
        guard next == nil else {
            throw Info(["unable to parse number in", .mark(String(sequence))])
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
        // Finalize
        //=--------------------------------------=
        self.integer.removeZerosAsPrefix(); self.integer.makeAtLeastZero()        
    }
}
