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
// MARK: * Style
//*============================================================================*

class StyleTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Overrides
    //=------------------------------------------------------------------------=
    
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
        
    func XCTAssert<F: NumberTextFormat>(_ value: F.FormatInput, format: F, result: String) {
         XCTAssertEqual(format.precision(.fractionLength(0...)).format(value), result)
    }
    
    /// Fraction limits is set to max because a style's default precision depends on context.
    func XCTInterpret<F: NumberTextFormat>(_ value: F.FormatInput, format: F, info: @autoclosure () -> Any) {
        let characters = format.precision(.fractionLength(0...)).format(value)
        let commit = _NumberTextStyle(format).precision(NumberTextPrecision(fraction: 0...)).interpret(value)
        XCTAssertEqual(commit.value, value, String(describing: info()))
        XCTAssertEqual(commit.snapshot.characters, characters, String(describing: info()))
    }

    //=------------------------------------------------------------------------=
    // MARK: Locales
    //=------------------------------------------------------------------------=
    
    /// Iterates about 1k times.
    func XCTInterpretLocales<T>(_ value: T.FormatInput,
    format: (Locale) -> T) where T: NumberTextFormat {
        //=--------------------------------------=
        // Locales
        //=--------------------------------------=
        for locale in locales {
            XCTInterpret(value, format: format(locale), info: locale)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Locales, Currencies
    //=------------------------------------------------------------------------=
    
    /// Iterates about 300k times.
    func XCTInterpretLocalesXCurrencies<T>(_ value: T.FormatInput,
    format: (String, Locale) -> T) where T: NumberTextFormat {
        //=--------------------------------------=
        // Locales, Currencies
        //=--------------------------------------=
        for locale in locales {
            for code in currencyCodes {
                XCTInterpret(value, format: format(code, locale), info: (locale, code))
            }
        }
    }
}

#endif
