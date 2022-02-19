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
// MARK: * NumberTests
//*============================================================================*

final class NumberTests: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let options: Set<Options> = [.decimal, .double, .int]
    
    //*========================================================================*
    // MARK: * Options
    //*========================================================================*
    
    enum Options { case decimal, double, int }
}

//=----------------------------------------------------------------------------=
// MARK: + Types
//=----------------------------------------------------------------------------=

extension NumberTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() throws {
        try XCTSkipUnless(options.contains(.decimal))
        //=--------------------------------------=
        // MARK: Locale, Currencies
        //=--------------------------------------=
        testAvailableLocales(
        Decimal.FormatStyle.self,
        Decimal(string: "-1234567.89")!)
    }
        
    func testDouble() throws {
        try XCTSkipUnless(options.contains(.double))
        //=--------------------------------------=
        // MARK: Locale, Currencies
        //=--------------------------------------=
        testAvailableLocales(
        FloatingPointFormatStyle<Double>.self,
        Double("-1234567.89")!)
    }
    
    func testInt() throws {
        try XCTSkipUnless(options.contains(.int))
        //=--------------------------------------=
        // MARK: Locale, Currencies
        //=--------------------------------------=
        testAvailableLocales(
        IntegerFormatStyle<Int>.self,
        Int("-123456789")!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    /// Iterates about 1k times.
    func testAvailableLocales<F: Formats.Number>(_ format: F.Type, _ value: F.Value) {
        //=--------------------------------------=
        // MARK: Currencies, Locales
        //=--------------------------------------=
        for locale in locales {
            let style = NumericTextStyle(F.init(locale: locale))
            let format = style.format.precision(.fractionLength(0...))
            //=------------------------------=
            // MARK: Comparables
            //=------------------------------=
            let commit = style.locale(locale).interpret(value)
            let characters = format.locale(locale).format(value)
            //=------------------------------=
            // MARK: Value
            //=------------------------------=
            guard commit.value == value else {
                XCTFail("\(commit.value) != \(value) ... \((locale))")
                return
            }
            //=------------------------------=
            // MARK: Characters
            //=------------------------------=
            guard commit.snapshot.characters == characters else {
                XCTFail("\(commit.snapshot.characters) != \(characters) ... \((locale))")
                return
            }
        }
    }
}

#endif
