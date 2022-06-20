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
// MARK: * Count x Tests
//*============================================================================*

final class CountTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Where
    //=------------------------------------------------------------------------=
    
    func testCountWhere() {
        let numbers = "22122"
        XCTAssertEqual(numbers.count(where: { $0 == "1" }), 1)
        XCTAssertEqual(numbers.count(where: { $0 == "2" }), 4)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x While
    //=------------------------------------------------------------------------=
    
    func testCountWhile() {
        let numbers = "22122"
        XCTAssertEqual(numbers.count(while: { $0 == "1" }), 0)
        XCTAssertEqual(numbers.count(while: { $0 == "2" }), 2)
    }
}

#endif
