//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Standard x ID
//*============================================================================*

@usableFromInline final class StandardID: Localizable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let locale: Locale
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale) { self.locale = locale }
    
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

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension StandardID {
    
    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
    
    @inlinable func update(_ formatter: NumberFormatter) {
        formatter.locale = locale
    }
 
    @inlinable func links<T: Component>(_ formatter: NumberFormatter) -> Links<T> {
        .standard(formatter)
    }
}
