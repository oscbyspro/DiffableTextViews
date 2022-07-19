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
// MARK: * Style x Tests x Percent
//*============================================================================*

final class StyleTestsOnPercent: StyleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssertLocales<T: _Value>(_ value: T) where T.NumberTextGraph: _Percentable {
        XCTAssertLocales(value, with: T.NumberTextGraph.Percent.init)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension StyleTestsOnPercent {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() throws {
        XCTAssertLocales(-1.23 as Decimal)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Floats
//=----------------------------------------------------------------------------=

extension StyleTestsOnPercent {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testFloat64_aka_Double() throws {
        XCTAssertLocales(-1.23 as Float64)
    }
}

#endif
