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
    
    func AssertIndexWorksAsExpected(_ encoding: (some Encoding).Type) {
        let max = encoding.distance(from: start, to:    end, in: emojis)
        let mid = encoding.distance(from: start, to: middle, in: emojis)
        let i = {
            encoding.index(at: $1, from: $0, in: self.emojis)
        }
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
        XCTAssertEqual(i(start, +max),   end)
        XCTAssertEqual(i(end,   -max), start)
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
        XCTAssertEqual(index, emojis.index(end, offsetBy: -0))
        
        index = i(-1,  index)
        XCTAssertEqual(index, emojis.index(end, offsetBy: -1))
        
        index = i(-1,  index)
        XCTAssertEqual(index, emojis.index(end, offsetBy: -2))
        XCTAssertEqual(index, start)
    }
}

#endif
