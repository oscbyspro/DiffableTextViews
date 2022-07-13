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
// MARK: * Style x Currency
//*============================================================================*

extension _Style_Currency:
_Style_Precision_Integer,
_Internal_Style_Precision_Integer
where Value: NumberTextValueXInteger { }

public struct _Style_Currency<Format: _Format_Currency>:
_Style_Internal_Base,
_Internal_Style_Bounds,
_Internal_Style_Precision {
    
    public typealias Value = Format.FormatInput
    public typealias Cache = _Cache_Currency<Format>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var locale: Locale
    @usableFromInline var currencyCode: String
    
    @usableFromInline var bounds: NumberTextBounds<Value>?
    @usableFromInline var precision: NumberTextPrecision<Value>?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(code: String, locale: Locale) {
        self.locale = locale; self.currencyCode = code
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func cache() -> Cache {
        fatalError()
    }
    
    @inlinable public func update(_ cache: inout Cache) {
        fatalError()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Value, with cache: inout Cache) -> String {
        fatalError()
    }
    
    @inlinable public func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value> {
        fatalError()
    }
    
    @inlinable public func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value> {
        fatalError()
    }
}
