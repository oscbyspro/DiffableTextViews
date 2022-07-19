//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKitXNumber

import XCTest

//*============================================================================*
// MARK: * Digit x Tests
//*============================================================================*

final class DigitTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssertASCII(_ digit: Digit, _ value: UInt8) {
         XCTAssertEqual(digit.numericValue, value)
         XCTAssertEqual(digit.character, Character(String(value)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testASCII() {
        XCTAssertASCII(.zero,  0)
        XCTAssertASCII(.one,   1)
        XCTAssertASCII(.two,   2)
        XCTAssertASCII(.three, 3)
        XCTAssertASCII(.four,  4)
        XCTAssertASCII(.five,  5)
        XCTAssertASCII(.six,   6)
        XCTAssertASCII(.seven, 7)
        XCTAssertASCII(.eight, 8)
        XCTAssertASCII(.nine,  9)
    }
}

#endif
