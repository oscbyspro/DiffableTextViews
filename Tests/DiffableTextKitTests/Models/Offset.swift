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
    typealias C = Offset<Character>

    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities x Comparable
    //=------------------------------------------------------------------------=

    func testEqual() {
        XCTAssertEqual(   C(3), C(3))
        XCTAssertNotEqual(C(3), C(7))
    }

    func testCompare() {
        XCTAssertLessThan(   C(3), C(7))
        XCTAssertGreaterThan(C(7), C(3))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities x Arithmetic
    //=------------------------------------------------------------------------=

    func testNegation() {
        XCTAssertEqual(-C(3), C(-3))
    }

    func testAddition() {
        XCTAssertEqual(C(1) + C(2), C(3))
    }

    func testAdditionInout() {
        var offset = C(1)
        offset    += C(2)
        XCTAssertEqual(offset, C(3))
    }

    func testSubtraction() {
        XCTAssertEqual(C(3) - C(2), C(1))
    }

    func testSubtractionInout() {
        var offset = C(3)
        offset    -= C(2)
        XCTAssertEqual(offset, C(1))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Int
    //=------------------------------------------------------------------------=

    func testIntInit() {
        XCTAssertEqual(Int(C(3)), 3)
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Range
    //=------------------------------------------------------------------------=

    func testRangeIsRandomAccessCollection() {
        XCTAssert(C(0) ..< C(1) is any RandomAccessCollection)
    }
}

#endif
