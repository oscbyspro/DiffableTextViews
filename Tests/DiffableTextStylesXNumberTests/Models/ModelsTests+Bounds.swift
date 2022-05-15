//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import XCTest
@testable import DiffableTextStylesXNumber

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class ModelsTestsXBounds: XCTestCase {
    typealias Style<T: NumberTextFormat> = _NumberTextStyle<T>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let integer = NumberTextStyle<Int>.number
    let decimal = NumberTextStyle<Decimal>.number
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var outside: Decimal {
        .greatestFiniteMagnitude
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssert<T: NumberTextFormat>(_ style: Style<T>, expectation: ClosedRange<T.FormatInput>) {
         XCTAssert(style.bounds, expectation: expectation)
    }
    
    func XCTAssert<T: NumberTextValue>(_ bounds: NumberTextBounds<T>, expectation: ClosedRange<T>) {
         XCTAssertEqual(bounds.min, expectation.lowerBound)
         XCTAssertEqual(bounds.max, expectation.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInt() {
        XCTAssertEqual(Int.bounds.lowerBound, Int.min)
        XCTAssertEqual(Int.bounds.upperBound, Int.max)
    }
    
    func testDecimal() {
        XCTAssertEqual(Decimal.bounds.lowerBound, -Decimal(string: String(repeating: "9", count: 38))!)
        XCTAssertEqual(Decimal.bounds.upperBound, +Decimal(string: String(repeating: "9", count: 38))!)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Initializers
//=----------------------------------------------------------------------------=

extension ModelsTestsXBounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Clamps To Limits
    //=------------------------------------------------------------------------=
    
    func testOutside() {
        XCTAssertLessThan(   (-outside), Decimal.bounds.lowerBound)
        XCTAssertGreaterThan((+outside), Decimal.bounds.upperBound)
    }
    
    func testOutsideClosedRange() {
        XCTAssert(NumberTextBounds((-outside)...(+outside)), expectation: Decimal.bounds)
    }
    
    func testOutsidePartialRangeFrom() {
        XCTAssert(NumberTextBounds((-outside)...), expectation: Decimal.bounds)
    }
    
    func testOutsidePartialRangeThrough() {
        XCTAssert(NumberTextBounds(...(+outside)), expectation: Decimal.bounds)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Integer
//=----------------------------------------------------------------------------=

extension ModelsTestsXBounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    func testInteger_ClosedRange() {
        XCTAssert(integer.bounds(5...9), expectation: 5...9)
    }
    
    func testInteger_PartialRangeFrom() {
        XCTAssert(integer.bounds(5... ), expectation: 5...Int.max)
    }
    
    func testInteger_PartialRangeThrough() {
        XCTAssert(integer.bounds( ...9), expectation: Int.min...9)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Floating Point
//=----------------------------------------------------------------------------=

extension ModelsTestsXBounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    func testFloatingPoint_ClosedRange() {
        XCTAssert(decimal.bounds(5...9), expectation: 5...9)
    }
    
    func testFloatingPoint_PartialRangeFrom() {
        XCTAssert(decimal.bounds(5... ), expectation: 5...Decimal.bounds.upperBound)
    }
    
    func testFloatingPoint_PartialRangeThrough() {
        XCTAssert(decimal.bounds( ...9), expectation: Decimal.bounds.lowerBound...9)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Autocorrect
//=----------------------------------------------------------------------------=

extension ModelsTestsXBounds {

    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAutocorrectSign(_ bounds: (Int, Int), positive: Sign, negative: Sign) {
        let bounds = NumberTextBounds(unchecked:  bounds)
        let autocorrect = bounds.autocorrectSignOnUnambigiousBounds(_:)
        XCTAssertEqual(positive, Sign.positive.transformed(autocorrect))
        XCTAssertEqual(negative, Sign.negative.transformed(autocorrect))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAutocorrectSign() {
        XCTAutocorrectSign((-1, 1), positive: .positive, negative: .negative) // unchanged
        XCTAutocorrectSign((-1, 0), positive: .negative, negative: .negative) // negatives
        XCTAutocorrectSign(( 0, 1), positive: .positive, negative: .positive) // positives
        XCTAutocorrectSign(( 0, 0), positive: .positive, negative: .positive) // positives
    }
}

#endif
