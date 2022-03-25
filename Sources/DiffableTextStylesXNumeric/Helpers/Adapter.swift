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
// MARK: * Adapter
//*============================================================================*

@usableFromInline struct Adapter<Format: NumericTextFormat>: Equatable {
    @usableFromInline typealias Value  = Format.FormatInput
    @usableFromInline typealias Scheme = Format.NumericTextScheme
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let format: Format
    @usableFromInline let scheme: Scheme
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ format: Format) {
        self.format = format.autocorrect()
        self.scheme = self.format.scheme()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Preferences
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds() -> Bounds<Value> {
        scheme.bounds(Value.self)
    }
    
    @inlinable func precision() -> Precision<Value> {
        scheme.precision(Value.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(_ locale: Locale) {
        self = Self(format.locale(locale))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.format == rhs.format
    }
}
