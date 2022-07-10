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
// MARK: * Components x Tests
//*============================================================================*

final class ComponentsTests: XCTestCase {
    typealias Standard = NumberTextSchemeXStandard
    
    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
    
    @inlinable func int(_ scheme: Standard) -> IntegerFormatStyle<Int> {
        .number.locale(scheme.id.locale)
    }
    
    @inlinable func double(_ scheme: Standard) -> FloatingPointFormatStyle<Double> {
        .number.locale(scheme.id.locale)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSigns() {
        let positive: Int = +1
        let negative: Int = -1
        //=--------------------------------------=
        // Lexicons
        //=--------------------------------------=
        for scheme in standards {
            let signs = scheme.reader.components.signs
            let style = int(scheme).sign(strategy: .always())
            let positives = positive.formatted(style)
            let negatives = negative.formatted(style)
            XCTAssertNotNil(positives.first(where: { signs[$0] != nil }))
            XCTAssertNotNil(negatives.first(where: { signs[$0] != nil }))
        }
    }
    
    func testDigits() {
        let number: Int = 1234567890
        //=--------------------------------------=
        // Lexicons
        //=--------------------------------------=
        for scheme in standards {
            let digits = scheme.reader.components.digits
            let style = int(scheme).grouping(.never)
            let numbers = number.formatted(style)
            XCTAssert(numbers.allSatisfy({ digits[$0] != nil }))
        }
    }
    
    func testGroupingSeparators() {
        let number: Int = 1234567890
        //=--------------------------------------=
        // Lexicons
        //=--------------------------------------=
        for scheme in standards {
            let separators = scheme.reader.components.separators
            let style = int(scheme).grouping(.automatic)
            let nonnumbers = number.formatted(style).filter({ !$0.isNumber })
            XCTAssert(nonnumbers.allSatisfy({ separators[$0] == .grouping }))
        }
    }
    
    func testFractionSeparators() {
        let number: Double = 0.123
        //=--------------------------------------=
        // Lexicons
        //=--------------------------------------=
        for scheme in standards {
            let separators = scheme.reader.components.separators
            let style = double(scheme).decimalSeparator(strategy: .always)
            let nonnumbers = number.formatted(style).filter({ !$0.isNumber })
            XCTAssert(nonnumbers.allSatisfy({ separators[$0] == .fraction }))
        }
    }
}

#endif
