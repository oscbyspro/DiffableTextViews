//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import DiffableTextKitXNumber

import XCTest

//*============================================================================*
// MARK: * Style
//*============================================================================*

class StyleTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Overrides
    //=------------------------------------------------------------------------=
    
    override func setUp() {
        super.setUp(); self.continueAfterFailure = false
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssert<S: _Style>(_ value: S.Value, with style: S) {
        let style = style.precision(fraction: 0...)
        var cache = style.cache()

        let commit = style.interpret(value, with: &cache)
        XCTAssertEqual(commit.value, value, "\(style) x \(value)")
        
        let characters = style.format(value, with: &cache)
        XCTAssertEqual(commit.snapshot.characters, characters, "\(style) x \(value)")
    }

    //=------------------------------------------------------------------------=
    // MARK: Locales
    //=------------------------------------------------------------------------=
    
    /// - Iterates about 1k times.
    func XCTAssertLocales<T: _Style>(_ value: T.Value, with style: (Locale) -> T) {
        for locale in locales {
            XCTAssert(value, with: style(locale))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Locales, Currencies
    //=------------------------------------------------------------------------=
    
    /// - Iterates about 300k times.
    func XCTAssertCurrencies<T: _Style>(_ value: T.Value, with style: (String, Locale) -> T) {
        for locale in locales {
            for code in currencyCodes {
                XCTAssert(value, with: style(code, locale))
            }
        }
    }
}

#endif
