//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Adapter
//*============================================================================*

public struct NumberTextAdapter<Format: NumberTextFormat>: Equatable {
    @usableFromInline typealias Value  = Format.FormatInput
    @usableFromInline typealias Scheme = Format.NumberTextScheme
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let format: Format
    @usableFromInline let scheme: Scheme
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: Format) {
        self.format = unchecked
        self.scheme = unchecked.scheme()
    }

    @inlinable @inline(__always) init(_ format: Format) {
        self.init(unchecked: format.rounded(.towardZero))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var reader: NumberTextReader {
        scheme.reader
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Preferences
    //=------------------------------------------------------------------------=
    
    @inlinable func preferred() -> NumberTextBounds<Value> {
        scheme.preferred(Value.self)
    }
    
    @inlinable func preferred() -> NumberTextPrecision<Value> {
        scheme.preferred(Value.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(_ locale: Locale) {
        guard format.locale != locale else { return }
        self = Self(unchecked: format.locale(locale))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        scheme.snapshot(characters)
    }
    
    @inlinable func value(_ number: Number) throws -> Value {
        try format.locale(.en_US_POSIX).parseStrategy.parse(number.description)
    }
    
    @inlinable func number(_ snapshot: Snapshot, as kind: (some NumberTextKind).Type) throws -> Number? {
        try reader.components.number(in: snapshot, as: kind)
    }
    
    @inlinable func number(_ proposal: Proposal, as kind: (some NumberTextKind).Type) throws -> Number? {
        try reader.number(proposal, as: kind)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.format == rhs.format
    }
}
