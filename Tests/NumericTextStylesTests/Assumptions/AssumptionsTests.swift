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
import Support
import XCTest

@testable import NumericTextStyles

//*============================================================================*
// MARK: * AssumptionsTests
//*============================================================================*

final class AssumptionsTests: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let enabled: Bool = true
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func skippable() throws {
        guard enabled else { throw XCTSkip() }
    }
}

#endif