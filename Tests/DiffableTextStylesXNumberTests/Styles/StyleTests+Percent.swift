//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import DiffableTestKit
@testable import DiffableTextStylesXNumber

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class StyleTestsXPercent: Tests, StyleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTInterpretLocales<T: NumberTextValueXPercentable>(_ value: T) {
         XCTInterpretLocales(value, format: T.NumberTextFormat.Percent.init)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Decimal
//=----------------------------------------------------------------------------=

extension StyleTestsXPercent {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() throws {
        XCTInterpretLocales(-1.23 as Decimal)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Floats
//=----------------------------------------------------------------------------=

extension StyleTestsXPercent {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testFloat64_aka_Double() throws {
        XCTInterpretLocales(-1.23 as Float64)
    }
}

#endif