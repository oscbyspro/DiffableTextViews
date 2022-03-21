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
// MARK: * Scheme
//*============================================================================*

public protocol NumericTextScheme {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var lexicon: Lexicon { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    /// Autocorrects a snapshot in ways specific to this instance.
    ///
    /// - It may mark currency expressions as virtual, for example.
    ///
    @inlinable func autocorrect(_ snapshot: inout Snapshot)
    
    //=------------------------------------------------------------------------=
    // MARK: Preferences
    //=------------------------------------------------------------------------=
    
    /// The bounds preferred by this instance.
    ///
    /// - The return value of this method MUST NOT depend on locale (v3.1.0).
    ///
    @inlinable func bounds<T>(_ value: T.Type) -> Bounds<T>
    
    /// The precision preferred by this instance.
    ///
    /// - The return value of this method MUST NOT depend on locale (v3.1.0).
    ///
    @inlinable func precision<T>(_ value: T.Type) -> Precision<T>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextScheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot) { }
    
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

@dynamicMemberLookup @usableFromInline
protocol NumericTextSchemeXReuseable: AnyObject, Identifiable, Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ id: ID)
    
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
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable static func reuse(_ id: ID) -> Self {
        cache.reuse(id, make: Self(id))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript<T>(dynamicMember keyPath: KeyPath<ID, T>) -> T {
        id[keyPath: keyPath]
    }
}
