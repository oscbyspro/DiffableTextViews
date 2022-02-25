//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Foundation
import Support

//*============================================================================*
// MARK: * Content
//*============================================================================*

@usableFromInline typealias Translation = NumericTextTranslation; @usableFromInline enum Translations {
    @usableFromInline typealias Standard = NumericTextStandardTranslation
    @usableFromInline typealias Currency = NumericTextCurrencyTranslation
    @usableFromInline typealias Cacheable = NumericTextCacheableTranslation
}

//*============================================================================*
// MARK: * Translation
//*============================================================================*

public protocol NumericTextTranslation {
    
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

extension NumericTextTranslation {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale {
        lexicon.locale
    }
}

//*============================================================================*
// MARK: * Translation x Cacheable
//*============================================================================*

@usableFromInline protocol NumericTextCacheableTranslation: AnyObject, Translation {
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

extension NumericTextCacheableTranslation {
    
    //=------------------------------------------------------------------------=
    // MARK: Search
    //=------------------------------------------------------------------------=
        
    @inlinable static func search(_ key: ID) -> Self {
        cache.search(key, make: Self(key))
    }
}
