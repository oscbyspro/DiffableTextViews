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
// MARK: * Style x Tests x Bounds
//*============================================================================*

final class StyleTestsOnBounds: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let integer = NumberTextStyle<Int>()
    let decimal = NumberTextStyle<Decimal>()
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssert<T>(_ style: some _DefaultStyle<T>, _ expectation: ClosedRange<T>?) {
        XCTAssertEqual(style.bounds?.min, expectation?.lowerBound)
        XCTAssertEqual(style.bounds?.max, expectation?.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int
    //=------------------------------------------------------------------------=
    
    func testInteger_ClosedRange() {
        XCTAssert(integer.bounds(5...9), 5...9)
    }
    
    func testInteger_PartialRangeFrom() {
        XCTAssert(integer.bounds(5... ), 5...Int.max)
    }
    
    func testInteger_PartialRangeThrough() {
        XCTAssert(integer.bounds( ...9), Int.min...9)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decimal
    //=------------------------------------------------------------------------=
    
    func testFloatingPoint_ClosedRange() {
        XCTAssert(decimal.bounds(5...9), Decimal(5)...9)
    }
    
    func testFloatingPoint_PartialRangeFrom() {
        XCTAssert(decimal.bounds(5... ), 5...(Decimal.max))
    }
    
    func testFloatingPoint_PartialRangeThrough() {
        XCTAssert(decimal.bounds( ...9), (Decimal.min)...9)
    }
}

#endif

