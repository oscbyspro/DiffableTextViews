//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKit

import XCTest

//*============================================================================*
// MARK: * Index x Tests
//*============================================================================*

final class IndexTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let characters = "ABC"
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities
    //=------------------------------------------------------------------------=
    
    func testComparableUsesOnlyAttribute() {
        XCTAssertEqual(
        Index(characters  .endIndex, as: 0),
        Index(characters.startIndex, as: 0))
        
        XCTAssertLessThan(
        Index(characters  .endIndex, as: 0),
        Index(characters.startIndex, as: 1))
    }
}

#endif
