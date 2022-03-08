//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import DiffableTestKit
@testable import DiffableTextStylesXNumeric

//*============================================================================*
// MARK: * HelpersTests x Count
//*============================================================================*

final class HelpersTests_Count: Tests {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let count = Count(value: 0, integer: 1, fraction: 2)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLanes() {
        XCTAssertEqual(count, Count(SIMD3(0, 1, 2)))
    }
    
    func testAccessors() {
        XCTAssertEqual(count.value,    0)
        XCTAssertEqual(count.integer,  1)
        XCTAssertEqual(count.fraction, 2)
    }
    
    func testComponents() {
        XCTAssertEqual(count[.value],    0)
        XCTAssertEqual(count[.integer],  1)
        XCTAssertEqual(count[.fraction], 2)
    }
    
    func testFirstWhere() {
        XCTAssertEqual(count.first(where: (.==, 0)), .value)
        XCTAssertEqual(count.first(where: (.==, 1)), .integer)
        XCTAssertEqual(count.first(where: (.==, 2)), .fraction)
    }
}

#endif
