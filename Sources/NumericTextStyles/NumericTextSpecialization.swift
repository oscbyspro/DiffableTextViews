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

#warning("Rename as Adapter, maybe.")
#warning("Wrap a FormatStyle, maybe.")
//=----------------------------------------------------------------------------=
// MARK: Table of Contents
//=----------------------------------------------------------------------------=

@usableFromInline typealias Specialization = NumericTextSpecialization

//*============================================================================*
// MARK: * Specialization
//*============================================================================*

public protocol NumericTextSpecialization {
    
    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
    
    #warning("Could make internal, maybe.")
    @inlinable var lexicon: Lexicon { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(snapshot: inout Snapshot)
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextSpecialization {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale { lexicon.locale }
}
