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
// MARK: + Loop
//=----------------------------------------------------------------------------=

extension FormatTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Locales
    //=------------------------------------------------------------------------=
    
    /// Iterates about 1k times.
    func XCTInterpretLocales<T: Format>(_ value: T.Value, format: (Locale) -> T) {
        for locale in locales {
            guard XCTInterpret(value, format: format(locale), info: locale) else { return }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Locales, Currencies
    //=------------------------------------------------------------------------=
    
    /// Iterates about 144k times.
    func XCTInterpretLocalesXCurrencies<T: Format>(_ value: T.Value, format: (String, Locale) -> T) {
        for locale in locales {
            for code in currencyCodes {
                guard XCTInterpret(value, format: format(code, locale), info: (locale, code)) else { return }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTInterpret<F: Format>(_ value: F.Value, format: F, info: @autoclosure () -> Any) -> Bool {
        let style = NumericTextStyle(format)
        //=--------------------------------------=
        // MARK: Testables
        //=--------------------------------------=
        let commit = style.interpret(value)
        let characters = format.precision(.fractionLength(0...)).format(value)
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        guard commit.value == value else {
            XCTFail("\(commit.value) != \(value) ... \((info()))")
            return false
        }
        //=--------------------------------------=
        // MARK: Characters
        //=--------------------------------------=
        guard commit.snapshot.characters == characters else {
            XCTFail("\(commit.snapshot.characters) != \(characters) ... \((info()))")
            return false
        }
        //=--------------------------------------=
        // MARK: Success
        //=--------------------------------------=
        return true
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Inaccurate
//=----------------------------------------------------------------------------=

extension FormatTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssert<F: Format>(_ value: F.Value, format: F, result: String) {
        XCTAssertEqual(format.precision(.fractionLength(0...)).format(value), result)
    }
}

#endif
