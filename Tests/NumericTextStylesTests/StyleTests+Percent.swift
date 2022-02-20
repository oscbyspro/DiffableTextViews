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
// MARK: * StyleTests x Percent
//*============================================================================*

final class StyleTestsXPercent: StyleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTInterpretLocales<T: Value.Percent>(_ value: T) {
         XCTInterpretLocales(value, format: T.Percent.init)
    }
    
    func XCTAssert<T: Value.Percent>(_ value: T, result: String) {
         XCTAssert(value, format: T.Percent(locale: en_US), result: result)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension StyleTestsXPercent {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() throws {
        XCTInterpretLocales(Decimal(string: "-1.23")!)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Floats
//=----------------------------------------------------------------------------=

extension StyleTestsXPercent {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testFloat64() throws {
        XCTInterpretLocales(-1.23 as Float64)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests - Inaccurate
    //=------------------------------------------------------------------------=
    
    func testFloat16IsInaccurate() {
        XCTAssert(-1.23 as Float16, result: "-123.046875%")
    }
    
    func testFloat32IsInaccurate() {
        XCTAssert(-1.23 as Float32, result: "-123.00000190734863%")
    }
}

#endif
