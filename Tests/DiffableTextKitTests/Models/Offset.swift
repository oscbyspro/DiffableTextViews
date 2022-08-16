//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKit

import XCTest

//*============================================================================*
// MARK: * Offset x Tests
//*============================================================================*

final class OffsetTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities x Comparable
    //=------------------------------------------------------------------------=

    func testEqual() {
        XCTAssertEqual(   C(3), C(3))
        XCTAssertNotEqual(C(3), C(7))
    }

    func testCompare() {
        XCTAssertLessThan(   C(3), C(7))
        XCTAssertGreaterThan(C(7), C(3))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities x Arithmetic
    //=------------------------------------------------------------------------=

    func testNegation() {
        XCTAssertEqual(-C(3), C(-3))
    }

    func testAddition() {
        XCTAssertEqual(C(1) + C(2), C(3))
    }

    func testAdditionInout() {
        var offset = C(1)
        offset    += C(2)
        XCTAssertEqual(offset, C(3))
    }

    func testSubtraction() {
        XCTAssertEqual(C(3) - C(2), C(1))
    }

    func testSubtractionInout() {
        var offset = C(3)
        offset    -= C(2)
        XCTAssertEqual(offset, C(1))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Int
    //=------------------------------------------------------------------------=

    func testIntInit() {
        XCTAssertEqual(Int(C(3)), 3)
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Range
    //=------------------------------------------------------------------------=

    func testRangeIsRandomAccessCollection() {
        XCTAssert(C(0) ..< C(1) is any RandomAccessCollection)
    }
}

//*============================================================================*
// MARK: * Encoding x Tests
//*============================================================================*

final class EncodingTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    lazy var emojis = Snapshot("🇸🇪🇺🇸")
    lazy var start  = emojis.startIndex
    lazy var middle = emojis.index(start, offsetBy: 1)
    lazy var end    = emojis.endIndex

    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func AssertIndexSubcomponentsAreEqual(_ lhs: Index, _ rhs: Index) {
        XCTAssertEqual(lhs.character, rhs.character)
        XCTAssertEqual(lhs.attribute, rhs.attribute)
    }
    
    func AssertDistancePerEmoji<T>(_ type: T.Type, _ stride: Offset<T>) {
        XCTAssertEqual(T.distance(from:  start, to:  start, in: emojis),  stride * 0)
        XCTAssertEqual(T.distance(from: middle, to: middle, in: emojis),  stride * 0)
        XCTAssertEqual(T.distance(from:    end, to:    end, in: emojis),  stride * 0)

        XCTAssertEqual(T.distance(from:  start, to: middle, in: emojis),  stride * 1)
        XCTAssertEqual(T.distance(from: middle, to:  start, in: emojis), -stride * 1)

        XCTAssertEqual(T.distance(from: middle, to:    end, in: emojis),  stride * 1)
        XCTAssertEqual(T.distance(from:    end, to: middle, in: emojis), -stride * 1)

        XCTAssertEqual(T.distance(from:  start, to:    end, in: emojis),  stride * 2)
        XCTAssertEqual(T.distance(from:    end, to:  start, in: emojis), -stride * 2)
    }

    func AssertIndexAwayFromIndexWorks(_ type: (some Encoding).Type) {
        let max = type.distance(from: start, to:    end, in: emojis)
        let mid = type.distance(from: start, to: middle, in: emojis)
        let i = { type.index(from: $0, move: $1, in:    self.emojis) }
        //=--------------------------------------=
        // Forwards, Backwards x SE
        //=--------------------------------------=
        for distance in 0 ..< mid {
            XCTAssertEqual(emojis[i(start, distance      )], "🇸🇪")
            XCTAssertEqual(emojis[i(end,   distance - max)], "🇸🇪")
        }
        //=--------------------------------------=
        // Forwards, Backwards x US
        //=--------------------------------------=
        for distance in mid ..< max {
            XCTAssertEqual(emojis[i(start, distance      )], "🇺🇸")
            XCTAssertEqual(emojis[i(end,   distance - max)], "🇺🇸")
        }
        //=--------------------------------------=
        // Forwards, Backwards x End To End
        //=--------------------------------------=
        AssertIndexSubcomponentsAreEqual(i(start, +max),   end)
        AssertIndexSubcomponentsAreEqual(i(end,   -max), start)
    }

    func AssertIndexClampsToStartOfCharacter(_ type: (some Encoding).Type) {
        let i = { type   .index(from: $0, move: $1, in: self.emojis) }
        let d = { type.distance(from: $0,   to: $1, in: self.emojis) }
        //=--------------------------------------=
        // Forwards
        //=--------------------------------------=
        for distance in 0 ..< d(start, middle) {
            AssertIndexSubcomponentsAreEqual(i(start, distance),  start)
        }

        for distance in d(start, middle) ..< d(middle, end) {
            AssertIndexSubcomponentsAreEqual(i(start, distance), middle)
        }

        AssertIndexSubcomponentsAreEqual(i(start, d(start, end)),   end)
        //=--------------------------------------=
        // Backwards
        //=--------------------------------------=
        var index = end
        AssertIndexSubcomponentsAreEqual(index, emojis.index(end, offsetBy: -0))

        index = i(index, -1)
        AssertIndexSubcomponentsAreEqual(index, emojis.index(end, offsetBy: -1))

        index = i(index, -1)
        AssertIndexSubcomponentsAreEqual(index, emojis.index(end, offsetBy: -2))
        AssertIndexSubcomponentsAreEqual(index, start)
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Character
    //=------------------------------------------------------------------------=

    func testCharacterDistance() {
        AssertDistancePerEmoji(Character.self, 1)
    }

    func testCharacterIndex() {
        AssertIndexAwayFromIndexWorks(Character.self)
    }

    func testCharacterIndexClampsToStartOfCharacter() {
        AssertIndexClampsToStartOfCharacter(Character.self)
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Unicode.Scaler
    //=------------------------------------------------------------------------=

    func testUnicodeScalarDistance() {
        AssertDistancePerEmoji(Unicode.Scalar.self, 2)
    }

    func testUnicodeScalarIndex() {
        AssertIndexAwayFromIndexWorks(Unicode.Scalar.self)
    }

    func testUnicodeScalarIndexClampsToStartOfCharacter() {
        AssertIndexClampsToStartOfCharacter(Unicode.Scalar.self)
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x UTF16
    //=------------------------------------------------------------------------=

    func testUTF16Distance() {
        AssertDistancePerEmoji(UTF16.self, 4)
    }

    func testUTF16Index() {
        AssertIndexAwayFromIndexWorks(UTF16.self)
    }

    func testUTF16IndexClampsToStartOfCharacter() {
        AssertIndexClampsToStartOfCharacter(UTF16.self)
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x UTF8
    //=------------------------------------------------------------------------=

    func testUTF8Distance() {
        AssertDistancePerEmoji(UTF8.self, 8)
    }

    func testUTF8Index() {
        AssertIndexAwayFromIndexWorks(UTF8.self)
    }
    
    func testUTF8IndexClampsToStartOfCharacter() {
        AssertIndexClampsToStartOfCharacter(UTF8.self)
    }
}

#endif
