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
// MARK: * Precision x Tests
//*============================================================================*

final class PrecisionTests: XCTestCase {
    typealias Range = ClosedRange<Int>
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssert<T: _Value>(_ precision: Precision<T>, integer: Range, fraction: Range) {
        //=--------------------------------------=
        // Integer
        //=--------------------------------------=
        XCTAssertEqual(precision.integer.lowerBound, integer.lowerBound)
        XCTAssertEqual(precision.integer.upperBound, integer.upperBound)
        //=--------------------------------------=
        // Fraction
        //=--------------------------------------=
        XCTAssertEqual(precision.fraction.lowerBound, fraction.lowerBound)
        XCTAssertEqual(precision.fraction.upperBound, fraction.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() {
        XCTAssert(Precision<Decimal>(),
        integer: ( 01)...(38), fraction: ( 00)...(38))
        XCTAssert(Precision<Decimal>(
        integer: ( 07)...(07), fraction: ( 07)...(07)),
        integer: ( 07)...(07), fraction: ( 07)...(07))
        XCTAssert(Precision<Decimal>(
        integer: (-99)...(99), fraction: (-99)...(99)),
        integer: ( 01)...(38), fraction: ( 00)...(38))
    }
    
    func testDouble() {
        XCTAssert(Precision<Double>(),
        integer: ( 01)...(15), fraction: ( 00)...(15))
        XCTAssert(Precision<Double>(
        integer: ( 07)...(07), fraction: ( 07)...(07)),
        integer: ( 07)...(07), fraction: ( 07)...(07))
        XCTAssert(Precision<Double>(
        integer: (-99)...(99), fraction: (-99)...(99)),
        integer: ( 01)...(15), fraction: ( 00)...(15))
    }
    
    func testInt() {
        XCTAssert(Precision<Int>(),
        integer: ( 01)...(19), fraction: ( 00)...(00))
        XCTAssert(Precision<Int>(
        integer: ( 07)...(07), fraction: ( 07)...(07)),
        integer: ( 07)...(07), fraction: ( 00)...(00))
        XCTAssert(Precision<Int>(
        integer: (-99)...(99), fraction: (-99)...(99)),
        integer: ( 01)...(19), fraction: ( 00)...(00))
    }
}

#endif
