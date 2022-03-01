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
// MARK: * Translation x Standard
//*============================================================================*

@usableFromInline final class NumericTextTranslation_Standard: Translations.Reuseable {
    @usableFromInline static let cache = Cache<ID, NumericTextTranslation_Standard>(33)

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let lexicon: Lexicon
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ key: ID) {
        self.lexicon = .standard(key.locale)
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func reuseable<T>(_ format: T) -> Self where T: Formats.Number {
        reuseable(ID(format.locale))
    }
    
    @inlinable static func reuseable<T>(_ format: T) -> Self where T: Formats.Percent {
        reuseable(ID(format.locale))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable public func autocorrect(_ snapshot: inout Snapshot) { }
    
    //*========================================================================*
    // MARK: * ID
    //*========================================================================*

    @usableFromInline final class ID: Hashable {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let locale: Locale
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ locale: Locale) {
            self.locale = locale
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Hashable
        //=--------------------------------------------------------------------=
        
        @inlinable func hash(into hasher: inout Hasher) {
            hasher.combine(locale)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Comparisons
        //=--------------------------------------------------------------------=
        
        @inlinable static func == (lhs: ID, rhs: ID) -> Bool {
            lhs.locale == rhs.locale
        }
    }
}
