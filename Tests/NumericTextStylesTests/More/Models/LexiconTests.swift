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
// MARK: * LexiconTests
//*============================================================================*

final class LexiconTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
    
    func testThatThereAreManyLocales() {
        XCTAssertGreaterThanOrEqual(locales.count, 937)
    }
    
    func testThatThereAreManyCurrencyCodes() {
        XCTAssertGreaterThanOrEqual(currencyCodes.count, 153)
    }
    
    func testEachLocaleMapsToALexicon() {
        XCTAssertEqual(locales.count, standard.count)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Styles
//=----------------------------------------------------------------------------=

extension LexiconTests {

    //=------------------------------------------------------------------------=
    // MARK: Make
    //=------------------------------------------------------------------------=
    
    @inlinable func int(_ lexicon: Lexicon) -> IntegerFormatStyle<Int> {
        .number.locale(lexicon.locale)
    }
    
    @inlinable func double(_ lexicon: Lexicon) -> FloatingPointFormatStyle<Double> {
        .number.locale(lexicon.locale)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSigns() {
        continueAfterFailure = false
        let positive: Int = +1
        let negative: Int = -1
        //=--------------------------------------=
        // MARK: Lexicons
        //=--------------------------------------=
        for lexicon in standard {
            let style = int(lexicon).sign(strategy: .always())
            let positives = positive.formatted(style)
            let negatives = negative.formatted(style)
            XCTAssertNotNil(positives.first(where: { lexicon.signs[$0] != nil }))
            XCTAssertNotNil(negatives.first(where: { lexicon.signs[$0] != nil }))
        }
    }
    
    func testDigits() {
        continueAfterFailure = false
        let number: Int = 1234567890
        //=--------------------------------------=
        // MARK: Lexicons
        //=--------------------------------------=
        for lexicon in standard {
            let style = int(lexicon).grouping(.never)
            let numbers = number.formatted(style)
            XCTAssert(numbers.allSatisfy({ lexicon.digits[$0] != nil }))
        }
    }
    
    func testGroupingSeparators() {
        continueAfterFailure = false
        let number: Int = 1234567890
        //=--------------------------------------=
        // MARK: Lexicons
        //=--------------------------------------=
        for lexicon in standard {
            let style = int(lexicon).grouping(.automatic)
            let nonnumbers = number.formatted(style).filter({ !$0.isNumber })
            XCTAssert(nonnumbers.allSatisfy({ lexicon.separators[$0] == .grouping }))
        }
    }
    
    func testFractionSeparators() {
        continueAfterFailure = false
        let number: Double = 0.123
        //=--------------------------------------=
        // MARK: Lexicons
        //=--------------------------------------=
        for lexicon in standard {
            let style = double(lexicon).decimalSeparator(strategy: .always)
            let nonnumbers = number.formatted(style).filter({ !$0.isNumber })
            XCTAssert(nonnumbers.allSatisfy({ lexicon.separators[$0] == .fraction }))
        }
    }
}

#endif
