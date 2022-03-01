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
    @usableFromInline typealias Standard  = NumericTextTranslation_Standard
    @usableFromInline typealias Currency  = NumericTextTranslation_Currency
    @usableFromInline typealias Reuseable = NumericTextTranslation_Reuseable
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
// MARK: * Translation x Reusable
//*============================================================================*

@usableFromInline protocol NumericTextTranslation_Reuseable: AnyObject, Translation {
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

extension NumericTextTranslation_Reuseable {
    
    //=------------------------------------------------------------------------=
    // MARK: Search
    //=------------------------------------------------------------------------=
        
    @inlinable static func reuseable(_  key: ID) -> Self {
        cache.reuseable(key, make: Self(key))
    }
}
