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
    
    static func lexicon(_ locale: Locale) -> Lexicon
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    static func autocorrect(snapshot: inout Snapshot)
}
