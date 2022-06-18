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
// MARK: * Offset x Tests
//*============================================================================*

final class OffsetTests: XCTestCase {
    typealias T = Offset<Character>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities
    //=------------------------------------------------------------------------=
    
    func testEqual() {
        XCTAssertEqual(   T(3), T(3))
        XCTAssertNotEqual(T(3), T(7))
    }
    
    func testCompare() {
        XCTAssertLessThan(   T(3), T(7))
        XCTAssertGreaterThan(T(7), T(3))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities
    //=------------------------------------------------------------------------=
    
    func testAddition() {
        XCTAssertEqual(T(1) + T(2), T(3))
    }
    
    func testSubtraction() {
        XCTAssertEqual(T(3) - T(2), T(1))
    }
}

#endif

