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
// MARK: * Content
//*============================================================================*

@usableFromInline typealias Scheme = NumericTextScheme; @usableFromInline enum Schemes {
    @usableFromInline typealias Standard  = NumericTextSchemeXStandard
    @usableFromInline typealias Currency  = NumericTextSchemeXCurrency
    @usableFromInline typealias Reuseable = NumericTextSchemeXReuseable
}

//*============================================================================*
// MARK: * Translation
//*============================================================================*

public protocol NumericTextScheme {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var lexicon: Lexicon { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Defaults
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds<Value>(_ value: Value.Type) -> Bounds<Value>
    
    @inlinable func precision<Value>(_ value: Value.Type) -> Precision<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot)
}

//*============================================================================*
// MARK: * Scheme x Reusable
//*============================================================================*

@usableFromInline protocol NumericTextSchemeXReuseable: AnyObject, Scheme {
    associatedtype ID: Hashable
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ key: ID)
    
    //=------------------------------------------------------------------------=
    // MARK: Cache
    //=------------------------------------------------------------------------=

    @inlinable static var cache: Cache<ID, Self> { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextSchemeXReuseable {
    
    //=------------------------------------------------------------------------=
    // MARK: Search
    //=------------------------------------------------------------------------=
        
    @inlinable static func reuseable(_ key: ID) -> Self {
        cache.reuse(key, make: Self(key))
    }
}
