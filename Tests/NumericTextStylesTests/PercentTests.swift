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
// MARK: * PercentTests
//*============================================================================*

final class PercentTests: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let options = Set<Options>(Options.allCases)
    
    //*========================================================================*
    // MARK: * Options
    //*========================================================================*
    
    enum Options: CaseIterable { case decimal, double }
}

//=----------------------------------------------------------------------------=
// MARK: + Types
//=----------------------------------------------------------------------------=

extension PercentTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() throws {
        try XCTSkipUnless(options.contains(.decimal))
        testAvailableLocales(Decimal(string: "-1234567.89")!)
    }
        
    func testDouble() throws {
        try XCTSkipUnless(options.contains(.double))
        testAvailableLocales(Double("-1234567.89")!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    /// Iterates about 1k times.
    func testAvailableLocales<T: Value.Percent>(_ value: T) {
        //=--------------------------------------=
        // MARK: Currencies, Locales
        //=--------------------------------------=
        for locale in locales {
            let style = NumericTextStyle(T.Percent(locale: locale))
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

//=----------------------------------------------------------------------------=
// MARK: + Restrictions
//=----------------------------------------------------------------------------=

extension PercentTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFloat16IsInaccurate() {
        XCTAseertIsInaccurate(Float16("1.23")!, result: "123.046875%")
    }
    
    func testFloat32IsInaccurate() {
        XCTAseertIsInaccurate(Float32("1.23")!, result: "123.000002%")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    func XCTAseertIsInaccurate<T: Value.Percent>(_ value: T, result: String) {
        XCTAssertEqual(T.Percent(locale: en_US).format(value), result)
    }
}

#endif
