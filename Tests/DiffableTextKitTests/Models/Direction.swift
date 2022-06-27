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
// MARK: * Direction x Tests
//*============================================================================*

final class DirectionTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInit() {
        XCTAssertEqual(Direction(from: 0, to: 0), .none)
        XCTAssertEqual(Direction(from: 0, to: 1), .forwards)
        XCTAssertEqual(Direction(from: 1, to: 0), .backwards)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Accessors
    //=------------------------------------------------------------------------=
    
    func testOpposite() {
        XCTAssertEqual(Direction .forwards.opposite, .backwards)
        XCTAssertEqual(Direction.backwards.opposite,  .forwards)
    }
}

#endif
