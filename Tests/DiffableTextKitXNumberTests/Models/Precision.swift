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
    typealias Limits = ClosedRange<Int>
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssert<T>(_ precision: _Precision<T>,
    digits: Limits, integer: Limits, fraction: Limits) {
        let lower = precision.lower()
        let upper = precision.upper()
        //=--------------------------------------=
        // Integer
        //=--------------------------------------=
        XCTAssertEqual(lower.integer, integer.lowerBound)
        XCTAssertEqual(upper.integer, integer.upperBound)
        //=--------------------------------------=
        // Integer
        //=--------------------------------------=
        XCTAssertEqual(lower.integer, integer.lowerBound)
        XCTAssertEqual(upper.integer, integer.upperBound)
        //=--------------------------------------=
        // Fraction
        //=--------------------------------------=
        XCTAssertEqual(lower.fraction, fraction.lowerBound)
        XCTAssertEqual(upper.fraction, fraction.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() {
        let digits   = 1...38
        let integer  = 1...38
        let fraction = 0...38
        
        var precision = _Precision<Decimal>()
        XCTAssert(precision, digits: digits, integer: integer, fraction: fraction)
        
        precision = _Precision<Decimal>(7...7)
        XCTAssert(precision, digits:  7...7, integer: integer, fraction: fraction)
        
        precision = _Precision<Decimal>(integer: 7...7, fraction: 7...7)
        XCTAssert(precision, digits: digits, integer: 7...7, fraction: 7...7)
        
        precision = _Precision<Decimal>(integer: (-99)...99, fraction: (-99)...99)
        XCTAssert(precision, digits: digits, integer: integer, fraction: fraction)
    }
    
    func testDouble() {
        let digits   = 1...15
        let integer  = 1...15
        let fraction = 0...15
        
        var precision = _Precision<Double>()
        XCTAssert(precision, digits: digits, integer: integer, fraction: fraction)
        
        precision = _Precision<Double>(7...7)
        XCTAssert(precision, digits:  7...7, integer: integer, fraction: fraction)
        
        precision = _Precision<Double>(integer: 7...7, fraction: 7...7)
        XCTAssert(precision, digits: digits, integer: 7...7, fraction: 7...7)
        
        precision = _Precision<Double>(integer: (-99)...99, fraction: (-99)...99)
        XCTAssert(precision, digits: digits, integer: integer, fraction: fraction)
    }
    
    func testInt() {
        let digits   = 1...18 // 9s
        let integer  = 1...18 // 9s
        let fraction = 0...00
        
        var precision = _Precision<Int>()
        XCTAssert(precision, digits: digits, integer: integer, fraction: fraction)
        
        precision = _Precision<Int>( 7...7)
        XCTAssert(precision, digits: 7...7, integer: integer, fraction: fraction)
        
        precision = _Precision<Int>(integer: 7...7, fraction: 7...7)
        XCTAssert(precision, digits: digits, integer: 7...7, fraction: fraction)
        
        precision = _Precision<Int>(integer: (-99)...99, fraction: (-99)...99)
        XCTAssert(precision, digits: digits, integer: integer, fraction: fraction)
    }
    
    func testUInt() {
        let digits   = 1...18 // 9s
        let integer  = 1...18 // 9s
        let fraction = 0...00
        
        var precision = _Precision<UInt>()
        XCTAssert(precision, digits: digits, integer: integer, fraction: fraction)
        
        precision = _Precision<UInt>(7...7)
        XCTAssert(precision, digits: 7...7, integer: integer, fraction: fraction)
        
        precision = _Precision<UInt>(integer: 7...7, fraction: 7...7)
        XCTAssert(precision, digits: digits, integer: 7...7, fraction: fraction)
        
        precision = _Precision<UInt>(integer: (-99)...99, fraction: (-99)...99)
        XCTAssert(precision, digits: digits, integer: integer, fraction: fraction)
    }
}

#endif
