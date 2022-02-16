//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import Foundation
@testable import NumericTextStyles

//*============================================================================*
// MARK: * Constants
//*============================================================================*

var locales: [Locale] {
    Earth.locales
}

var regions: [Region] {
    Earth.regions
}

var currencies: [String] {
    Earth.currencies
}

#endif
