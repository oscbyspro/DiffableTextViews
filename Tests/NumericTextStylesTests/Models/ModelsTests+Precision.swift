//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import Foundation
import XCTest

@testable import NumericTextStyles

//*============================================================================*
// MARK: * ModelsTests x Precision
//*============================================================================*

final class ModelsTestsXPrecision: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let seven = (+07)...(+07)
    let large = (-99)...(+99)

    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssert<T: Value>(_ precision: Precision<T>, integer: ClosedRange<Int>, fraction: ClosedRange<Int>) {
        //=--------------------------------------=
        // MARK: Integer
        //=--------------------------------------=
        XCTAssertEqual(precision.lower.value, 1)
        XCTAssertEqual(precision.lower.integer, integer.lowerBound)
        XCTAssertEqual(precision.upper.integer, integer.upperBound)
        //=--------------------------------------=
        // MARK: Fraction
        //=--------------------------------------=
        XCTAssertEqual(precision.upper.value, T.precision.value)
        XCTAssertEqual(precision.lower.fraction, fraction.lowerBound)
        XCTAssertEqual(precision.upper.fraction, fraction.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() {
        XCTAssert(Precision<Decimal>(),
        integer: 01...38, fraction: 00...38)
        XCTAssert(Precision<Decimal>(integer: seven, fraction: seven),
        integer: 07...07, fraction: 07...07)
        XCTAssert(Precision<Decimal>(integer: large, fraction: large),
        integer: 01...38, fraction: 00...38)
    }
    
    func testDouble() {
        XCTAssert(Precision<Double>(),
        integer: 01...15, fraction: 00...15)
        XCTAssert(Precision<Double>(integer: seven, fraction: seven),
        integer: 07...07, fraction: 07...07)
        XCTAssert(Precision<Double>(integer: large, fraction: large),
        integer: 01...15, fraction: 00...15)
    }
    
    func testInt() {
        XCTAssert(Precision<Int>(),
        integer: 01...19, fraction: 0...0)
        XCTAssert(Precision<Int>(integer: seven),
        integer: 07...07, fraction: 0...0)
        XCTAssert(Precision<Int>(integer: large),
        integer: 01...19, fraction: 0...0)
    }
}

#endif
