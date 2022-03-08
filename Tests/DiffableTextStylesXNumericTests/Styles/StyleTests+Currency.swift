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
// MARK: * StyleTests x Currency
//*============================================================================*

/// - There are about 144k locale-currency pairs, so it may take a while.
final class StyleTests_Currency: Tests, StyleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTInterpretLocalesXCurrencies<T: Values.Currencyable>(_ value: T) {
         XCTInterpretLocalesXCurrencies(value, format: T.FormatStyle.Currency.init)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension StyleTests_Currency {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() throws {
        XCTInterpretLocalesXCurrencies(Decimal(string: "-1.23")!)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Floats
//=----------------------------------------------------------------------------=

extension StyleTests_Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFloat64_aka_Double() throws {
        XCTInterpretLocalesXCurrencies(-1.23 as Float64)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Ints
//=----------------------------------------------------------------------------=

extension StyleTests_Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testInt() throws {
        XCTInterpretLocalesXCurrencies(-123 as Int)
    }
    
    func testInt8() throws {
        XCTInterpretLocalesXCurrencies(-123 as Int8)
    }
    
    func testInt16() throws {
        XCTInterpretLocalesXCurrencies(-123 as Int16)
    }
    
    func testInt32() throws {
        XCTInterpretLocalesXCurrencies(-123 as Int32)
    }
    
    func testInt64() throws {
        XCTInterpretLocalesXCurrencies(-123 as Int64)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UInts
//=----------------------------------------------------------------------------=

extension StyleTests_Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt() throws {
        XCTInterpretLocalesXCurrencies(123 as UInt)
    }
    
    func testUInt8() throws {
        XCTInterpretLocalesXCurrencies(123 as UInt8)
    }
    
    func testUInt16() throws {
        XCTInterpretLocalesXCurrencies(123 as UInt16)
    }
    
    func testUInt32() throws {
        XCTInterpretLocalesXCurrencies(123 as UInt32)
    }
    
    func testUInt64() throws {
        XCTInterpretLocalesXCurrencies(123 as UInt64)
    }
}

#endif
