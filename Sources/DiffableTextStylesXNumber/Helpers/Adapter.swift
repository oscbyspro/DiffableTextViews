//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: Declaration
//*============================================================================*

@usableFromInline struct Adapter<Format: NumberTextFormat>: Equatable {
    @usableFromInline typealias Value  = Format.Value
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
    
    @inlinable func bounds() -> NumberTextBounds<Value> {
        scheme.bounds(Value.self)
    }
    
    @inlinable func precision() -> NumberTextPrecision<Value> {
        scheme.precision(Value.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(_ locale: Locale) {
        self = Self(unchecked: format.locale(locale))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.format == rhs.format
    }
}
