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
// MARK: * CurrencyTests
//*============================================================================*

/// - There are many 144k locale-currency pairs, so it will take some time.
/// - Apple's format style cache will allocate ~100 MB per type that is tested.
final class CurrencyTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let options: Set<Options> = [.decimal]
    
    //*========================================================================*
    // MARK: * Options
    //*========================================================================*
    
    enum Options { case decimal, double, int }
}

//=----------------------------------------------------------------------------=
// MARK: + Tests
//=----------------------------------------------------------------------------=

extension CurrencyTests {

    //=------------------------------------------------------------------------=
    // MARK: Values
    //=------------------------------------------------------------------------=
    
    func testDecimal() throws {
        try XCTSkipUnless(options.contains(.decimal))
        //=--------------------------------------=
        // MARK: Locale, Currencies
        //=--------------------------------------=
        testAvailableLocaleCurrencyPairs(
        Decimal.FormatStyle.Currency.self,
        Decimal(string: "-1234567.89")!)
    }
        
    func testDouble() throws {
        try XCTSkipUnless(options.contains(.double))
        //=--------------------------------------=
        // MARK: Locale, Currencies
        //=--------------------------------------=
        testAvailableLocaleCurrencyPairs(
        FloatingPointFormatStyle<Double>.Currency.self,
        Double("-1234567.89")!)
    }
    
    func testInt() throws {
        try XCTSkipUnless(options.contains(.int))
        //=--------------------------------------=
        // MARK: Locale, Currencies
        //=--------------------------------------=
        testAvailableLocaleCurrencyPairs(
        IntegerFormatStyle<Int>.Currency.self,
        Int("-123456789")!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    /// Loops about 144k times.
    func testAvailableLocaleCurrencyPairs<F: Formats.Currency>(_ format: F.Type, _ value: F.Value) {
        //=--------------------------------------=
        // MARK: Currencies, Locales
        //=--------------------------------------=
        for code in currencies {
            for locale in locales {
                let style = NumericTextStyle(F.init(code: code, locale: locale))
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
                    XCTFail("\(commit.value) != \(value)... \((locale, code))")
                    return
                }
                //=------------------------------=
                // MARK: Characters
                //=------------------------------=
                guard commit.snapshot.characters == characters else {
                    XCTFail("\(commit.snapshot.characters) != \(characters) ... \((locale, code))")
                    return
                }
            }
        }
    }
}

#endif
