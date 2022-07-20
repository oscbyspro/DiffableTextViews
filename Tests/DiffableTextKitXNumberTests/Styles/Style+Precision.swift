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
// MARK: * Style x Tests x Precision
//*============================================================================*

final class StyleTestsOnPrecision: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let integer = NumberTextStyle<Int>()
    let decimal = NumberTextStyle<Decimal>()
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssert<T>(_ style: _DefaultStyle<T>,
    integer: ClosedRange<Int>?, fraction: ClosedRange<Int>?) {
        XCTAssertEqual(style.precision?.integer,  integer )
        XCTAssertEqual(style.precision?.fraction, fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Integer
    //=------------------------------------------------------------------------=
    
    func testInteger_Length() {
        XCTAssert(integer.precision(7), integer: 7...7, fraction: 0...0)
    }
    
    func testInteger_Limits() {
        XCTAssert(integer.precision(5...9), integer: 5...9, fraction: 0...0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Float
    //=------------------------------------------------------------------------=
    
    func testFloatingPoint_IntegerLength() {
        XCTAssert(decimal.precision(integer: 7), integer: 7...7, fraction: 0...38)
    }
    
    func testFloatingPoint_FractionLength() {
        XCTAssert(decimal.precision(fraction: 7), integer: 1...38, fraction: 7...7)
    }
    
    func testFloatingPoint_IntegerAndFractionLength() {
        XCTAssert(decimal.precision(integer: 5, fraction: 9), integer: 5...5, fraction: 9...9)
    }
    
    func testFloatingPoint_IntegerLimitsAndFractionLength() {
        XCTAssert(decimal.precision(integer: 5...6, fraction: 9), integer: 5...6, fraction: 9...9)
    }
    
    func testFloatingPoint_IntegerLengthAndFractionLimits() {
        XCTAssert(decimal.precision(integer: 5, fraction: 8...9), integer: 5...5, fraction: 8...9)
    }
    
    func testFloatingPoint_IntegerLimits() {
        XCTAssert(decimal.precision(integer: 5...6), integer: 5...6, fraction: 0...38)
    }
    
    func testFloatingPoint_FractionLimits() {
        XCTAssert(decimal.precision(fraction: 8...9), integer: 1...38, fraction: 8...9)
    }
    
    func testFloatingPoint_IntegerLimitsAndFractionLimits() {
        XCTAssert(decimal.precision(integer: 5...6, fraction: 8...9), integer: 5...6, fraction: 8...9)
    }
}

#endif

