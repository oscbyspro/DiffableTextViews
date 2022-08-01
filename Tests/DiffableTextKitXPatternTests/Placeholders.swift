//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKitXPattern

import XCTest

//*============================================================================*
// MARK: * Placeholders x Tests
//*============================================================================*

final class PlaceholdersTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var none = Placeholders.none
    lazy var some = Placeholders.some(Some(("#", \.isNumber)))
    lazy var many = Placeholders.many(Many(["#": \.isNumber, "@": \.isLetter]))
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    func TRUE(_ character: Character) -> Bool {  true }
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func AssertSubscriptResults(_ instance: Placeholders,
    _ values: () -> [(Character, Character, Bool?)]) {
        for value in values() {
            XCTAssertEqual(instance[value.0]?(value.1), value.2)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Accessors
    //=------------------------------------------------------------------------=
    
    func testNoneSomeManySubscript() {
        AssertSubscriptResults(none) {[
        ("#", "1", nil),
        ("#", "A", nil),
        ("@", "1", nil),
        ("@", "A", nil),
        ("_", "1", nil),
        ("_", "A", nil)]}
        
        AssertSubscriptResults(some) {[
        ("#", "1", true ),
        ("#", "A", false),
        ("@", "1", nil),
        ("@", "A", nil),
        ("_", "1", nil),
        ("_", "A", nil)]}
        
        AssertSubscriptResults(many) {[
        ("#", "1", true ),
        ("#", "A", false),
        ("@", "1", false),
        ("@", "A", true ),
        ("_", "1", nil),
        ("_", "A", nil)]}
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities
    //=------------------------------------------------------------------------=
    
    func testNoneSomeManyEquation() {
        XCTAssertEqual(none, none)
        XCTAssertEqual(some, some)
        XCTAssertEqual(many, many)
        
        XCTAssertNotEqual(none, some)
        XCTAssertNotEqual(none, many)
        XCTAssertNotEqual(some, many)
        
        XCTAssertNotEqual(
        Placeholders.some(Some(("A", TRUE))),
        Placeholders.some(Some(("_", TRUE))))
        
        XCTAssertNotEqual(
        Placeholders.many(Many(["A": TRUE, "B": TRUE])),
        Placeholders.many(Many(["A": TRUE, "_": TRUE])))
    }
}

#endif
