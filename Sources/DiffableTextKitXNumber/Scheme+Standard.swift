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

@usableFromInline final class NumberTextSchemeXStandard: NumberTextSchemeXReuseable {
    @usableFromInline static let cache = Cache<ID, NumberTextSchemeXStandard>(32)

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let id: ID
    @usableFromInline let lexicon: Lexicon

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ id: ID) {
        //=--------------------------------------=
        // Formatter
        //=--------------------------------------=
        let formatter = NumberFormatter()
        formatter.locale = id.locale
        assert(formatter.numberStyle == .none)
        //=--------------------------------------=
        // Formatter: None
        //=--------------------------------------=
        self.id = id
        self.lexicon = .standard(formatter)
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func reuse<T>(_ format: T) -> Self
    where T: NumberTextFormatXNumber {
        reuse(ID(format.locale))
    }
    
    @inlinable static func reuse<T>(_ format: T) -> Self
    where T: NumberTextFormatXPercent {
        reuse(ID(format.locale))
    }
    
    //*========================================================================*
    // MARK: ID
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
