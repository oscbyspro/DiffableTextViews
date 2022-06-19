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
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var emojis = Snapshot("🇸🇪🇺🇸")
    lazy var start = emojis.startIndex
    lazy var end = emojis.endIndex
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func AssertSizeOf<T>(_ snapshot: Snapshot, _ size: Offset<T>) {
        XCTAssertEqual(T.distance(from: start, to: end, in: snapshot), size)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Character
    //=------------------------------------------------------------------------=
    
    func testCharacterDistanceWorks() {
        AssertSizeOf(emojis, .character(2))
    }
    
    func testCharacterIndexWorks() {
        let i = {
            Character.index(at: $0, from: $1, in: self.emojis)
        }
        //=--------------------------------------=
        // Forwards
        //=--------------------------------------=
        XCTAssertEqual(emojis[i(0, start)], "🇸🇪")
        XCTAssertEqual(emojis[i(1, start)], "🇺🇸")
        XCTAssertEqual(i(2, start),  end)
        //=--------------------------------------=
        // Backwards
        //=--------------------------------------=
        XCTAssertEqual(emojis[i(-2, end)], "🇸🇪")
        XCTAssertEqual(emojis[i(-1, end)], "🇺🇸")
        XCTAssertEqual(i(0, end),   end)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UTF16
    //=------------------------------------------------------------------------=
    
    func testUTF16DistanceWorks() {
        AssertSizeOf(emojis, .utf16(8))
    }
    
    func testUTF16IndexWorks() {
        let i = {
            UTF16.index(at: $0, from: $1, in: self.emojis)
        }
        //=--------------------------------------=
        // Forwards
        //=--------------------------------------=
        XCTAssertEqual(emojis[i(0, start)], "🇸🇪")
        XCTAssertEqual(emojis[i(1, start)], "🇸🇪")
        XCTAssertEqual(emojis[i(2, start)], "🇸🇪")
        XCTAssertEqual(emojis[i(3, start)], "🇸🇪")
        XCTAssertEqual(emojis[i(4, start)], "🇺🇸")
        XCTAssertEqual(emojis[i(5, start)], "🇺🇸")
        XCTAssertEqual(emojis[i(6, start)], "🇺🇸")
        XCTAssertEqual(emojis[i(7, start)], "🇺🇸")
        XCTAssertEqual(i(8, start),  end)
        //=--------------------------------------=
        // Backwards
        //=--------------------------------------=
        XCTAssertEqual(emojis[i(-8, end)], "🇸🇪")
        XCTAssertEqual(emojis[i(-7, end)], "🇸🇪")
        XCTAssertEqual(emojis[i(-6, end)], "🇸🇪")
        XCTAssertEqual(emojis[i(-5, end)], "🇸🇪")
        XCTAssertEqual(emojis[i(-4, end)], "🇺🇸")
        XCTAssertEqual(emojis[i(-3, end)], "🇺🇸")
        XCTAssertEqual(emojis[i(-2, end)], "🇺🇸")
        XCTAssertEqual(emojis[i(-1, end)], "🇺🇸")
        XCTAssertEqual(i(0, end),   end)
    }
    
    func testUTF16IndexClampsToStartOfCharacter() {
        let i = {
            UTF16.index(at: $0, from: $1, in: self.emojis)
        }
        //=--------------------------------------=
        // Forwards
        //=--------------------------------------=
        XCTAssertEqual(i(0, start), start)
        XCTAssertEqual(i(1, start), start)
        XCTAssertEqual(i(2, start), start)
        XCTAssertEqual(i(3, start), start)
        XCTAssertEqual(i(4, start), emojis.index(after: start))
        //=--------------------------------------=
        // Backwards
        //=--------------------------------------=
        var index = end
        XCTAssertEqual(index, emojis.index(start, offsetBy: 2))
        
        index = i(-1,  index)
        XCTAssertEqual(index, emojis.index(start, offsetBy: 1))
        
        index = i(-1,  index)
        XCTAssertEqual(index, emojis.index(start, offsetBy: 0))
    }
}

#endif
