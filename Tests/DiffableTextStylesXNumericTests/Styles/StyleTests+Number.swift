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
@testable import DiffableTextStylesXNumeric

//*============================================================================*
// MARK: * StyleTests x Number
//*============================================================================*

final class StyleTests_Number: Tests, StyleTests {

    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTInterpretLocales<T: Value>(_ value: T) where T.FormatStyle: Formats.Number {
         XCTInterpretLocales(value, format: T.FormatStyle.init)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension StyleTests_Number {

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

extension StyleTests_Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testFloat64_aka_Double() throws {
        XCTInterpretLocales(-1.23 as Float64)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Ints
//=----------------------------------------------------------------------------=

extension StyleTests_Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testInt() throws {
        XCTInterpretLocales(-123 as Int)
    }
    
    func testInt8() throws {
        XCTInterpretLocales(-123 as Int8)
    }
    
    func testInt16() throws {
        XCTInterpretLocales(-123 as Int16)
    }
    
    func testInt32() throws {
        XCTInterpretLocales(-123 as Int32)
    }
    
    func testInt64() throws {
        XCTInterpretLocales(-123 as Int64)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UInts
//=----------------------------------------------------------------------------=

extension StyleTests_Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt() throws {
        XCTInterpretLocales(123 as UInt)
    }
    
    func testUInt8() throws {
        XCTInterpretLocales(123 as UInt8)
    }
    
    func testUInt16() throws {
        XCTInterpretLocales(123 as UInt16)
    }
    
    func testUInt32() throws {
        XCTInterpretLocales(123 as UInt32)
    }
    
    func testUInt64() throws {
        XCTInterpretLocales(123 as UInt64)
    }
}
#endif
