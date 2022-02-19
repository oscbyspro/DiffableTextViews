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

extension FormatTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Locales
    //=------------------------------------------------------------------------=
    
    /// Iterates about 1k times.
    func XCTAssertAvailableLocales<T: Format>(_ value: T.Value, format: (Locale) -> T) {
        for locale in locales {
            XCTAssertCommit(format(locale), value: value, info: locale)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Locales, Currencies
    //=------------------------------------------------------------------------=
    
    /// Iterates about 144k times.
    func XCTAssertAvailableLocalesXCurrencies<T: Format>(_ value: T.Value, format: (String, Locale) -> T) {
        for locale in locales {
            for currency in currencies {
                print(currency, locale, value)
                XCTAssertCommit(format(currency, locale), value: value, info: (locale, currency))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    func XCTAssertCommit<F: Format>(_ format: F, value: F.Value, info: @autoclosure () -> Any) {
        let style = NumericTextStyle(format); let comparable = format.precision(.fractionLength(0...))
        //=------------------------------=
        // MARK: Testables
        //=------------------------------=
        let commit = style.interpret(value)
        let characters = comparable.format(value)
        //=------------------------------=
        // MARK: Value
        //=------------------------------=
        guard commit.value == value else {
            XCTFail("\(commit.value) != \(value) ... \((info()))")
            return
        }
        //=------------------------------=
        // MARK: Characters
        //=------------------------------=
        guard commit.snapshot.characters == characters else {
            XCTFail("\(commit.snapshot.characters) != \(characters) ... \((info()))")
            return
        }
    }
}

#endif
