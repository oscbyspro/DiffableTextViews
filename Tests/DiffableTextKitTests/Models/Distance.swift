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
// MARK: * Distance x Tests
//*============================================================================*

final class DistanceTests: XCTestCase {
    typealias Distances<T> = (Offset<T>, Offset<T>, Offset<T>) where T: Distance

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

    func Assert<T>(_ encoding: T.Type, distances: (Offset<T>, Offset<T>, Offset<T>)) {
        XCTAssertEqual(T.distance(from:  start, to:  start, in: emojis),  distances.0)
        XCTAssertEqual(T.distance(from: middle, to: middle, in: emojis),  distances.0)
        XCTAssertEqual(T.distance(from:    end, to:    end, in: emojis),  distances.0)

        XCTAssertEqual(T.distance(from:  start, to: middle, in: emojis), +distances.1)
        XCTAssertEqual(T.distance(from: middle, to:  start, in: emojis), -distances.1)

        XCTAssertEqual(T.distance(from: middle, to:    end, in: emojis), +distances.1)
        XCTAssertEqual(T.distance(from:    end, to: middle, in: emojis), -distances.1)

        XCTAssertEqual(T.distance(from:  start, to:    end, in: emojis), +distances.2)
        XCTAssertEqual(T.distance(from:    end, to:  start, in: emojis), -distances.2)
    }

    func AssertIndexSubcomponentsAreEqual(_ lhs: Index, _ rhs: Index) {
        XCTAssertEqual(lhs.character, rhs.character)
        XCTAssertEqual(lhs.attribute, rhs.attribute)
    }

    func AssertIndexWorksAsExpected(_ type: (some Distance).Type) {
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

    func AssertIndexClampsToStartOfCharacter(_ type: (some Distance).Type) {
        let i = { type.index(from: $0,  move: $1, in: self.emojis) }
        let d = { type.distance(from: $0, to: $1, in: self.emojis) }
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
        Assert(Character.self, distances: (0, 1, 2))
    }

    func testCharacterIndex() {
        AssertIndexWorksAsExpected(Character.self)
    }

    func testCharacterIndexClampsToStartOfCharacter() {
        AssertIndexClampsToStartOfCharacter(Character.self)
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Unicode.Scaler
    //=------------------------------------------------------------------------=

    func testUnicodeScalarDistance() {
        Assert(Unicode.Scalar.self, distances: (0, 2, 4))
    }

    func testUnicodeScalarIndex() {
        AssertIndexWorksAsExpected(Unicode.Scalar.self)
    }

    func testUnicodeScalarIndexClampsToStartOfCharacter() {
        AssertIndexClampsToStartOfCharacter(Unicode.Scalar.self)
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x UTF16
    //=------------------------------------------------------------------------=

    func testUTF16Distance() {
        Assert(UTF16.self, distances: (0, 4, 8))
    }

    func testUTF16Index() {
        AssertIndexWorksAsExpected(UTF16.self)
    }

    func testUTF16IndexClampsToStartOfCharacter() {
        AssertIndexClampsToStartOfCharacter(UTF16.self)
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x UTF8
    //=------------------------------------------------------------------------=

    func testUTF8Distance() {
        Assert(UTF8.self, distances: (0, 8, 16))
    }

    func testUTF8Index() {
        AssertIndexWorksAsExpected(UTF8.self)
    }

    func testUTF8IndexClampsToStartOfCharacter() {
        AssertIndexClampsToStartOfCharacter(UTF8.self)
    }
}

#endif
