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
// MARK: * Capacity x Tests
//*============================================================================*

final class CapacityTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInit() {
        let numbers = Array(capacity: 11) { $0 += [1] }
        XCTAssertGreaterThanOrEqual(numbers.capacity, 11)
        XCTAssertEqual(numbers, [1])
    }
}

#endif
