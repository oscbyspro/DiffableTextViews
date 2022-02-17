//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

#warning("WIP")
#warning("WIP")
#warning("WIP")

//*============================================================================*
// MARK: * Currency
//*============================================================================*

public enum Currency: NumericTextSpecialization {
    
    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
    
    @inlinable public static func character<T: Unit>(of component: T, using formatter: NumberFormatter) -> Character? {
        component.currency(formatter)
    }
}
