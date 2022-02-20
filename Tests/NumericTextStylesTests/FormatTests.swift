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
    func XCTInterpretLocales<T: Format>(_ value: T.Value, format: (Locale) -> T) {
        for locale in locales {
            XCTInterpret(value, format: format(locale), info: locale)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Locales, Currencies
    //=------------------------------------------------------------------------=
    
    /// Iterates about 144k times.
    func XCTInterpretLocalesXCurrencies<T: Format>(_ value: T.Value, format: (String, Locale) -> T) {
        for locale in locales {
            for currency in currencies {
                XCTInterpret(value, format: format(currency, locale), info: (locale, currency))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTInterpret<F: Format>(_ value: F.Value, format: F, info: @autoclosure () -> Any) {
        let style = NumericTextStyle(format)
        //=------------------------------=
        // MARK: Testables
        //=------------------------------=
        let commit = style.interpret(value)
        let characters = format.precision(.fractionLength(0...)).format(value)
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
