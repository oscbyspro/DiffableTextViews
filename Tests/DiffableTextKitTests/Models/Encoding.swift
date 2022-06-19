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
// MARK: * Encoding x Tests
//*============================================================================*

final class EncodingTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func AssertSizeOf<T>(_ snapshot: Snapshot, _ size: Offset<T>) {
        XCTAssertEqual(T.distance(from: snapshot.startIndex, to: snapshot.endIndex, in: snapshot), size)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Character
    //=------------------------------------------------------------------------=
    
    func testCharacterDistanceWorks() {
        AssertSizeOf(Snapshot("🇸🇪🇺🇸"), .character(2))
    }
    
    func testCharacterIndexWorks() {
        let emojis = Snapshot("🇸🇪🇺🇸")
        let s = emojis.startIndex
        let e = emojis  .endIndex
        let i = {
            Character.index(at: $0, from: $1, in: emojis)
        }
        //=--------------------------------------=
        // Forwards
        //=--------------------------------------=
        XCTAssertEqual(emojis[i(0, s)], "🇸🇪")
        XCTAssertEqual(emojis[i(1, s)], "🇺🇸")
        XCTAssertEqual(i(2, s), e)
        //=--------------------------------------=
        // Backwards
        //=--------------------------------------=
        XCTAssertEqual(emojis[i(-2, e)], "🇸🇪")
        XCTAssertEqual(emojis[i(-1, e)], "🇺🇸")
        XCTAssertEqual(i(0, e), e)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UTF16
    //=------------------------------------------------------------------------=
    
    func testUTF16DistanceWorks() {
        AssertSizeOf(Snapshot("🇸🇪🇺🇸"), .utf16(8))
    }
    
    func testUTF16IndexWorks() {
        let emojis = Snapshot("🇸🇪🇺🇸")
        let s = emojis.startIndex
        let e = emojis  .endIndex
        let i = {
            UTF16.index(at: $0, from: $1, in: emojis)
        }
        //=--------------------------------------=
        // Forwards
        //=--------------------------------------=
        XCTAssertEqual(emojis[i(0, s)], "🇸🇪")
        XCTAssertEqual(emojis[i(1, s)], "🇸🇪")
        XCTAssertEqual(emojis[i(2, s)], "🇸🇪")
        XCTAssertEqual(emojis[i(3, s)], "🇸🇪")
        XCTAssertEqual(emojis[i(4, s)], "🇺🇸")
        XCTAssertEqual(emojis[i(5, s)], "🇺🇸")
        XCTAssertEqual(emojis[i(6, s)], "🇺🇸")
        XCTAssertEqual(emojis[i(7, s)], "🇺🇸")
        XCTAssertEqual(i(8, s), e)
        //=--------------------------------------=
        // Backwards
        //=--------------------------------------=
        XCTAssertEqual("🇸🇪", emojis[i(-8, e)])
        XCTAssertEqual("🇸🇪", emojis[i(-7, e)])
        XCTAssertEqual("🇸🇪", emojis[i(-6, e)])
        XCTAssertEqual("🇸🇪", emojis[i(-5, e)])
        XCTAssertEqual("🇺🇸", emojis[i(-4, e)])
        XCTAssertEqual("🇺🇸", emojis[i(-3, e)])
        XCTAssertEqual("🇺🇸", emojis[i(-2, e)])
        XCTAssertEqual("🇺🇸", emojis[i(-1, e)])
        XCTAssertEqual(e, i(0, e))
    }
}

#endif
