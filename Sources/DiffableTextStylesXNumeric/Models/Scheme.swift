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
    associatedtype ID: Hashable

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var lexicon: Lexicon { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Preferences
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds<T>(_ value: T.Type) -> Bounds<T>
    
    @inlinable func precision<T>(_ value: T.Type) -> Precision<T>
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot)
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextScheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Preferences
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds<T>(_ value: T.Type) -> Bounds<T> where T: Value {
        Bounds()
    }
    
    @inlinable func precision<T>(_ value: T.Type) -> Precision<T> where T: Value {
        Precision()
    }
}

//*============================================================================*
// MARK: * Scheme x Reusable
//*============================================================================*

@usableFromInline protocol NumericTextSchemeXReuseable: AnyObject, Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ identifier: ID)
    
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
        
    @inlinable static func reuseable(_ identifier: ID) -> Self {
        cache.reuse(identifier, make: Self(identifier))
    }
}
