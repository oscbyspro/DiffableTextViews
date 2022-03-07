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
    @usableFromInline typealias Standard  = NumericTextScheme_Standard
    @usableFromInline typealias Currency  = NumericTextScheme_Currency
    @usableFromInline typealias Reuseable = NumericTextScheme_Reuseable
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
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot)
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextScheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale {
        lexicon.locale
    }
}

//*============================================================================*
// MARK: * Scheme x Reusable
//*============================================================================*

@usableFromInline protocol NumericTextScheme_Reuseable: AnyObject, Scheme {
    associatedtype ID: AnyObject & Hashable
    
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

extension NumericTextScheme_Reuseable {
    
    //=------------------------------------------------------------------------=
    // MARK: Search
    //=------------------------------------------------------------------------=
        
    @inlinable static func reuseable(_  key: ID) -> Self {
        cache.reuseable(key, make: Self(key))
    }
}
