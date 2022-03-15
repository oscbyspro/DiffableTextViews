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
// MARK: * Scheme x Standard
//*============================================================================*

@usableFromInline final class NumericTextSchemeXStandard: Schemes.Reuseable {
    @usableFromInline static let cache = Cache<ID, NumericTextSchemeXStandard>(33)

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let id: ID
    @usableFromInline let lexicon: Lexicon

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ id: ID) {
        let formatter = NumberFormatter()
        formatter.locale = id.locale
        assert(formatter.numberStyle == .none)
        //=--------------------------------------=
        // MARK: Instantiate
        //=--------------------------------------=
        self.id = id
        //=--------------------------------------=
        // MARK: Instantiate - None
        //=--------------------------------------=
        self.lexicon = .standard(formatter)
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func reuse<T>(_ format: T) -> Self where T: Formats.Number {
        reuse(ID(format.locale))
    }
    
    @inlinable static func reuse<T>(_ format: T) -> Self where T: Formats.Percent {
        reuse(ID(format.locale))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable public func autocorrect(_ snapshot: inout Snapshot) { }
    
    //*========================================================================*
    // MARK: * ID
    //*========================================================================*

    @usableFromInline struct ID: Hashable {
        
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
    }
}
