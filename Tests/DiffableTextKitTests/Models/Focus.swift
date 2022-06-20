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
// MARK: * Focus x Tests
//*============================================================================*

final class FocusTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInit() {
        XCTAssertEqual(Focus( true).wrapped,  true)
        XCTAssertEqual(Focus(false).wrapped, false)
    }
    
    func testInitAsBooleanLiteral() {
        XCTAssertEqual(Focus( true),  true)
        XCTAssertEqual(Focus(false), false)
    }
}

#endif
