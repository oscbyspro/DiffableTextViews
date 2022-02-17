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

#warning("Rename")
#warning("Rename")
#warning("Rename")
//=----------------------------------------------------------------------------=
// MARK: Table of Contents
//=----------------------------------------------------------------------------=

@usableFromInline typealias Specialization = NumericTextSpecialization

//*============================================================================*
// MARK: * Strategy
//*============================================================================*

public protocol NumericTextSpecialization {
    
    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
    
    static func character<T: Unit>(for component: T, in formatter: NumberFormatter) -> Character?
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    #warning("Maybe also make static.")
    func autocorrect(snapshot: inout Snapshot)
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextSpecialization {
    
    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
    
    @inlinable func character<T: Unit>(_ component: T, in formatter: NumberFormatter) throws -> Character {
        try character(formatter) ?! Info(["unable to localize", .mark(self)])
    }
}
