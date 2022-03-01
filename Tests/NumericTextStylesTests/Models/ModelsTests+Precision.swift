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

final class ModelsTests_Precision: XCTestCase {
    typealias Style<T: Format> = _NumericTextStyle<T>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let integer = Style<Int    .FormatStyle>.number
    let decimal = Style<Decimal.FormatStyle>.number
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssert<T: Format>(_ style: Style<T>,
    integer: ClosedRange<Int>, fraction: ClosedRange<Int>) {
        XCTAssert(style.precision, integer: integer, fraction: fraction)
    }
    
    func XCTAssert<T: Value>(_ precision: Precision<T>,
    integer: ClosedRange<Int>, fraction: ClosedRange<Int>) {
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
}

//=----------------------------------------------------------------------------=
// MARK: + Instances
//=----------------------------------------------------------------------------=

extension ModelsTests_Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() {
        XCTAssert(Precision<Decimal>(),
        integer: 01...38, fraction: 00...38)
        XCTAssert(Precision<Decimal>(integer: ( 07)...(07), fraction: ( 07)...(07)),
        integer: 07...07, fraction: 07...07)
        XCTAssert(Precision<Decimal>(integer: (-99)...(99), fraction: (-99)...(99)),
        integer: 01...38, fraction: 00...38)
    }
    
    func testDouble() {
        XCTAssert(Precision<Double>(),
        integer: 01...15, fraction: 00...15)
        XCTAssert(Precision<Double>(integer: ( 07)...(07), fraction: ( 07)...(07)),
        integer: 07...07, fraction: 07...07)
        XCTAssert(Precision<Double>(integer: (-99)...(99), fraction: (-99)...(99)),
        integer: 01...15, fraction: 00...15)
    }
    
    func testInt() {
        XCTAssert(Precision<Int>(),
        integer: 01...19, fraction: 00...00)
        XCTAssert(Precision<Int>(integer: ( 07)...(07)),
        integer: 07...07, fraction: 00...00)
        XCTAssert(Precision<Int>(integer: (-99)...(99)),
        integer: 01...19, fraction: 00...00)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Style x Integer
//=----------------------------------------------------------------------------=

extension ModelsTests_Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    func testInteger_Length() {
        XCTAssert(integer.precision(7), integer: 7...7, fraction: 0...0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=

    func testInteger_Limits() {
        XCTAssert(integer.precision(5...9), integer: 5...9, fraction: 0...0)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Style x Floating Point
//=----------------------------------------------------------------------------=

extension ModelsTests_Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Length
    //=------------------------------------------------------------------------=
    
    func testFloatingPoint_IntegerLength() {
        XCTAssert(decimal.precision(integer:  7), integer: 7...7, fraction: 0...38)
    }
    
    func testFloatingPoint_FractionLength() {
        XCTAssert(decimal.precision(fraction: 7), integer: 1...38, fraction: 7...7)
    }
    
    func testFloatingPoint_IntegerAndFractionLength() {
        XCTAssert(decimal.precision(integer:  5, fraction: 9), integer: 5...5, fraction: 9...9)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Mixed
    //=------------------------------------------------------------------------=
    
    func testFloatingPoint_IntegerLimitsAndFractionLength() {
        XCTAssert(decimal.precision(integer:  5...6, fraction: 9), integer: 5...6, fraction: 9...9)
    }
    
    func testFloatingPoint_IntegerLengthAndFractionLimits() {
        XCTAssert(decimal.precision(integer:  5, fraction: 8...9), integer: 5...5, fraction: 8...9)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    func testFloatingPoint_IntegerLimits() {
        XCTAssert(decimal.precision(integer:  5...6), integer: 5...6, fraction: 0...38)
    }
    
    func testFloatingPoint_FractionLimits() {
        XCTAssert(decimal.precision(fraction: 8...9), integer: 1...38, fraction: 8...9)
    }
    
    func testFloatingPoint_IntegerLimitsAndFractionLimits() {
        XCTAssert(decimal.precision(integer:  5...6, fraction: 8...9), integer: 5...6, fraction: 8...9)
    }
}

#endif
