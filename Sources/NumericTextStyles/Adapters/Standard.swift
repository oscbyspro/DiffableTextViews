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

#warning("It should cache.")
//*============================================================================*
// MARK: * Number
//*============================================================================*

final class NumericTextStandardAdapter: Adapter {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let lexicon: Lexicon
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    #warning("It should cache.")
    @inlinable init(locale: Locale) {
        self.lexicon = .standard(locale: locale)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable public func autocorrect(_ snapshot: inout Snapshot) { }
}


#warning("WIP")
#warning("WIP")
#warning("WIP")
//*============================================================================*
// MARK: * Standard x ID
//*============================================================================*

@usableFromInline final class StandardID: Hashable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let locale: Locale
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale) {
        self.locale = locale
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Hashable
    //=------------------------------------------------------------------------=
    
    @inlinable func hash(into hasher: inout Hasher) {
        hasher.combine(locale.identifier)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable static func == (lhs: StandardID, rhs: StandardID) -> Bool {
        lhs.locale.identifier == rhs.locale.identifier
    }
}
