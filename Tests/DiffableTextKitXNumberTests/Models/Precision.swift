////=----------------------------------------------------------------------------=
//// This source file is part of the DiffableTextViews open source project.
////
//// Copyright (c) 2022 Oscar Byström Ericsson
//// Licensed under Apache License, Version 2.0
////
//// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
////=----------------------------------------------------------------------------=
//
//#if DEBUG
//
//@testable import DiffableTextKitXNumber
//
//import XCTest
//
////*============================================================================*
//// MARK: * Precision x Tests
////*============================================================================*
//
//final class PrecisionTests: XCTestCase {
//    typealias Range = ClosedRange<Int>
//    typealias Style<T: _Format> = _NumberTextStyle<T>
//
//    //=------------------------------------------------------------------------=
//    // MARK: State
//    //=------------------------------------------------------------------------=
//    
//    let integer = NumberTextStyle<Int>.number
//    let decimal = NumberTextStyle<Decimal>.number
//    
//    //=------------------------------------------------------------------------=
//    // MARK: Assertions
//    //=------------------------------------------------------------------------=
//    
//    func XCTAssert<T: _Format>(_ style: Style<T>, integer: Range, fraction: Range) {
//         XCTAssert(style.precision, integer: integer, fraction: fraction)
//    }
//    
//    func XCTAssert<T: _Value>(_ precision: _Precision<T>, integer: Range, fraction: Range) {
//        //=--------------------------------------=
//        // Value
//        //=--------------------------------------=
//        XCTAssertEqual(precision.upper.value, T.precision)
//        //=--------------------------------------=
//        // Integer
//        //=--------------------------------------=
//        XCTAssertEqual(precision.integer.lowerBound, 1)
//        XCTAssertEqual(precision.integer.lowerBound, integer.lowerBound)
//        XCTAssertEqual(precision.integer.lowerBound, integer.upperBound)
//        //=--------------------------------------=
//        // Fraction
//        //=--------------------------------------=
//        XCTAssertEqual(precision.fraction.lowerBound, 0)
//        XCTAssertEqual(precision.fraction.lowerBound, fraction.lowerBound)
//        XCTAssertEqual(precision.fraction.lowerBound, fraction.upperBound)
//    }
//}
//
////=----------------------------------------------------------------------------=
//// MARK: + Instances
////=----------------------------------------------------------------------------=
//
//extension PrecisionTests {
//    
//    //=------------------------------------------------------------------------=
//    // MARK: Tests
//    //=------------------------------------------------------------------------=
//    
//    func testDecimal() {
//        XCTAssert(_Precision<Decimal>(),
//        integer: ( 01)...(38), fraction: ( 00)...(38))
//        XCTAssert(_Precision<Decimal>(
//        integer: ( 07)...(07), fraction: ( 07)...(07)),
//        integer: ( 07)...(07), fraction: ( 07)...(07))
//        XCTAssert(_Precision<Decimal>(
//        integer: (-99)...(99), fraction: (-99)...(99)),
//        integer: ( 01)...(38), fraction: ( 00)...(38))
//    }
//    
//    func testDouble() {
//        XCTAssert(_Precision<Double>(),
//        integer: ( 01)...(15), fraction: ( 00)...(15))
//        XCTAssert(_Precision<Double>(
//        integer: ( 07)...(07), fraction: ( 07)...(07)),
//        integer: ( 07)...(07), fraction: ( 07)...(07))
//        XCTAssert(_Precision<Double>(
//        integer: (-99)...(99), fraction: (-99)...(99)),
//        integer: ( 01)...(15), fraction: ( 00)...(15))
//    }
//    
//    func testInt() {
//        XCTAssert(_Precision<Int>(),
//        integer: ( 01)...(19), fraction: ( 00)...(00))
//        XCTAssert(_Precision<Int>(
//        integer: ( 07)...(07), fraction: ( 07)...(07)),
//        integer: ( 07)...(07), fraction: ( 00)...(00))
//        XCTAssert(_Precision<Int>(
//        integer: (-99)...(99), fraction: (-99)...(99)),
//        integer: ( 01)...(19), fraction: ( 00)...(00))
//    }
//}
//
////=----------------------------------------------------------------------------=
//// MARK: + Integer
////=----------------------------------------------------------------------------=
//
//extension PrecisionTests {
//    
//    //=------------------------------------------------------------------------=
//    // MARK: Length
//    //=------------------------------------------------------------------------=
//    
//    func testInteger_Length() {
//        XCTAssert(integer.precision(7), integer: 7...7, fraction: 0...0)
//    }
//    
//    //=------------------------------------------------------------------------=
//    // MARK: Limits
//    //=------------------------------------------------------------------------=
//
//    func testInteger_Limits() {
//        XCTAssert(integer.precision(5...9), integer: 5...9, fraction: 0...0)
//    }
//}
//
////=----------------------------------------------------------------------------=
//// MARK: + Floating Point
////=----------------------------------------------------------------------------=
//
//extension PrecisionTests {
//    
//    //=------------------------------------------------------------------------=
//    // MARK: Length
//    //=------------------------------------------------------------------------=
//    
//    func testFloatingPoint_IntegerLength() {
//        XCTAssert(decimal.precision(integer: 7), integer: 7...7, fraction: 0...38)
//    }
//    
//    func testFloatingPoint_FractionLength() {
//        XCTAssert(decimal.precision(fraction: 7), integer: 1...38, fraction: 7...7)
//    }
//    
//    func testFloatingPoint_IntegerAndFractionLength() {
//        XCTAssert(decimal.precision(integer: 5, fraction: 9), integer: 5...5, fraction: 9...9)
//    }
//    
//    //=------------------------------------------------------------------------=
//    // MARK: Mixed
//    //=------------------------------------------------------------------------=
//    
//    func testFloatingPoint_IntegerLimitsAndFractionLength() {
//        XCTAssert(decimal.precision(integer: 5...6, fraction: 9), integer: 5...6, fraction: 9...9)
//    }
//    
//    func testFloatingPoint_IntegerLengthAndFractionLimits() {
//        XCTAssert(decimal.precision(integer: 5, fraction: 8...9), integer: 5...5, fraction: 8...9)
//    }
//    
//    //=------------------------------------------------------------------------=
//    // MARK: Limits
//    //=------------------------------------------------------------------------=
//    
//    func testFloatingPoint_IntegerLimits() {
//        XCTAssert(decimal.precision(integer: 5...6), integer: 5...6, fraction: 0...38)
//    }
//    
//    func testFloatingPoint_FractionLimits() {
//        XCTAssert(decimal.precision(fraction: 8...9), integer: 1...38, fraction: 8...9)
//    }
//    
//    func testFloatingPoint_IntegerLimitsAndFractionLimits() {
//        XCTAssert(decimal.precision(integer: 5...6, fraction: 8...9), integer: 5...6, fraction: 8...9)
//    }
//}
//
//#endif
