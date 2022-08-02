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
// MARK: * Bounds x Tests
//*============================================================================*

final class BoundsTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var outside: Decimal {
        .greatestFiniteMagnitude
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssert<T: _Value>(_ bounds: _Bounds<T>, _ expectation: ClosedRange<T>) {
        XCTAssertEqual(bounds.min, expectation.lowerBound)
        XCTAssertEqual(bounds.max, expectation.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Clamps To Limits
    //=------------------------------------------------------------------------=
    
    func testOutsideClosedRange() {
        XCTAssert(_Bounds((-outside)...(+outside)), (.min)...(.max))
    }
    
    func testOutsidePartialRangeFrom() {
        XCTAssert(_Bounds((-outside)...), (.min)...(.max))
    }
    
    func testOutsidePartialRangeThrough() {
        XCTAssert(_Bounds(...(+outside)), (.min)...(.max))
    }
    
    func testOutside() {
        XCTAssertLessThan(   (-outside), Decimal._NumberTextGraph.min)
        XCTAssertGreaterThan((+outside), Decimal._NumberTextGraph.max)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Autocorrection
//=----------------------------------------------------------------------------=

extension BoundsTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAutocorrectSign(_ bounds: (Int, Int), positive: Sign, negative: Sign) {
        let bounds = _Bounds(unchecked:  bounds)
        
        func autocorrected(_ sign: Sign) -> Sign {
            var sign = sign; bounds.autocorrect(&sign); return sign
        }
        
        XCTAssertEqual(autocorrected(.positive), positive)
        XCTAssertEqual(autocorrected(.negative), negative)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Sign
    //=------------------------------------------------------------------------=
    
    func testAutocorrectSign() {
        XCTAutocorrectSign((-1, 1), positive: .positive, negative: .negative) // unchanged
        XCTAutocorrectSign((-1, 0), positive: .negative, negative: .negative) // negatives
        XCTAutocorrectSign(( 0, 1), positive: .positive, negative: .positive) // positives
        XCTAutocorrectSign(( 0, 0), positive: .positive, negative: .positive) // positives
    }
}

#endif
