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
// MARK: * StyleTests
//*============================================================================*

protocol StyleTests: Tests { }

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension StyleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
        
    func XCTAssert<F: Format>(_ value: F.Value, format: F, result: String) {
        XCTAssertEqual(format.precision(.fractionLength(0...)).format(value), result)
    }
    
    /// Fraction limits is set to max because a style's default precision depends on context.
    func XCTInterpret<F: Format>(_ value: F.Value, format: F, info: @autoclosure () -> Any) {
        let characters = format.precision(.fractionLength(0...)).format(value)
        let commit = _NumericTextStyle(format).precision(Precision(fraction: 0...)).interpret(value)
        XCTAssertEqual(commit.value, value, String(describing: info()))
        XCTAssertEqual(commit.snapshot.characters, characters, String(describing: info()))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Style
//=----------------------------------------------------------------------------=

extension StyleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Locales
    //=------------------------------------------------------------------------=
    
    /// Iterates about 1k times.
    func XCTInterpretLocales<T: Format>(_ value: T.Value, format: (Locale) -> T) {
        //=--------------------------------------=
        // MARK: Locales
        //=--------------------------------------=
        for locale in locales {
            XCTInterpret(value, format: format(locale), info: locale)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Locales, Currencies
    //=------------------------------------------------------------------------=
    
    /// Iterates about 144k times.
    func XCTInterpretLocalesXCurrencies<T: Format>(_ value: T.Value, format: (String, Locale) -> T) {
        //=--------------------------------------=
        // MARK: Locales, Currencies
        //=--------------------------------------=
        for locale in locales {
            for code in currencyCodes {
                XCTInterpret(value, format: format(code, locale), info: (locale, code))
            }
        }
    }
}

#endif
