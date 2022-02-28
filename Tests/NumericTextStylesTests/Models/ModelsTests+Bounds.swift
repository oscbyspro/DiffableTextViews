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
@testable import NumericTextStyles

//*============================================================================*
// MARK: * ModelsTests x Bounds
//*============================================================================*

final class ModelsTests_Bounds: XCTestCase {
    typealias Style<T: Format> = _NumericTextStyle<T>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let integer = Style<Int    .Number>.number
    let decimal = Style<Decimal.Number>.number
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var outside: Decimal {
        .greatestFiniteMagnitude
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssert<T: Format>(_ style: Style<T>, expectation: ClosedRange<T.Value>) {
        XCTAssert(style.bounds, expectation: expectation)
    }
    
    func XCTAssert<T: Value>(_ bounds: Bounds<T>, expectation: ClosedRange<T>) {
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
// MARK: + Initializers
//=----------------------------------------------------------------------------=

extension ModelsTests_Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Clamps To Limits
    //=------------------------------------------------------------------------=
    
    func testOutside() {
        XCTAssertLessThan(   (-outside), Decimal.bounds.lowerBound)
        XCTAssertGreaterThan((+outside), Decimal.bounds.upperBound)
    }
    
    func testOutsideClosedRange() {
        XCTAssert(Bounds((-outside)...(+outside)), expectation: Decimal.bounds)
    }
    
    func testOutsidePartialRangeFrom() {
        XCTAssert(Bounds((-outside)...), expectation: Decimal.bounds)
    }
    
    func testOutsidePartialRangeThrough() {
        XCTAssert(Bounds(...(+outside)), expectation: Decimal.bounds)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Style x Integer
//=----------------------------------------------------------------------------=

extension ModelsTests_Bounds {
    
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
// MARK: + Style x Floating Point
//=----------------------------------------------------------------------------=

extension ModelsTests_Bounds {
    
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
// MARK: + Autocorrect
//=----------------------------------------------------------------------------=

extension ModelsTests_Bounds {

    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAutocorrectSign(_ bounds: (Int, Int), positive: Sign, negative: Sign) {
        let bounds = Bounds(unchecked: bounds)
        XCTAssertEqual(positive, Sign.positive.transform(bounds.autocorrect))
        XCTAssertEqual(negative, Sign.negative.transform(bounds.autocorrect))
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
