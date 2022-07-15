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
// MARK: * Internal x Optional
//*============================================================================*

@usableFromInline struct _Internal_Optional<Style>: DiffableTextStyleWrapper,
_Internal_Style where Style: _Internal_Standard {
    
    @usableFromInline typealias Value = Style.Value?
    @usableFromInline typealias Cache = Style.Cache
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ style: Style) {
        self.style  = style
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var bounds: NumberTextBounds<Input>? {
        get { style.bounds }
        set { style.bounds = newValue }
    }

    @inlinable var precision: NumberTextPrecision<Input>? {
        get { style.precision }
        set { style.precision = newValue }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_ value: Value, with cache: inout Cache) -> String {
        value.map({ style.format($0, with: &cache) }) ?? ""
    }

    @inlinable func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value> {
        value.map({ Commit(style.interpret($0, with: &cache)) }) ?? Commit()
    }

    @inlinable func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value> {
        try cache.optional(proposal).map({ try Commit(style.resolve($0,with: &cache)) }) ?? Commit<Value>()
    }
}
