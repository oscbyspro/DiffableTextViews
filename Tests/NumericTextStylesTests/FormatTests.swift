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
// MARK: * FormatTests
//*============================================================================*

protocol FormatTests: XCTestCase { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

#warning("DRY")
extension FormatTests {
    
    #warning("DRY")
    //=------------------------------------------------------------------------=
    // MARK: Locales
    //=------------------------------------------------------------------------=
    
    /// Iterates about 1k times.
    func XCTAssertAvailableLocales<T: Format>(_ value: T.Value, format: (Locale) -> T) {
        for locale in locales {
            let style = NumericTextStyle(format(locale))
            let format = style.format.precision(.fractionLength(0...))
            //=------------------------------=
            // MARK: Testables
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
    
    #warning("DRY")
    //=------------------------------------------------------------------------=
    // MARK: Locales, Currencies
    //=------------------------------------------------------------------------=
    
    /// Iterates about 144k times.
    func XCTAssertAvailableLocalesXCurrencies<T: Format>(_ value: T.Value, format: (String, Locale) -> T) {
        for locale in locales {
            for currency in currencies {
                let style = NumericTextStyle(format(currency, locale))
                let format = style.format.precision(.fractionLength(0...))
                //=------------------------------=
                // MARK: Testables
                //=------------------------------=
                let commit = style.locale(locale).interpret(value)
                let characters = format.locale(locale).format(value)
                //=------------------------------=
                // MARK: Value
                //=------------------------------=
                guard commit.value == value else {
                    XCTFail("\(commit.value) != \(value) ... \((locale, currency))")
                    return
                }
                //=------------------------------=
                // MARK: Characters
                //=------------------------------=
                guard commit.snapshot.characters == characters else {
                    XCTFail("\(commit.snapshot.characters) != \(characters) ... \((locale, currency))")
                    return
                }
            }
        }
    }
}

#endif
