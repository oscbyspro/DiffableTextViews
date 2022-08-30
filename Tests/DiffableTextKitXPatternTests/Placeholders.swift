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
    
    typealias Placeholders = PatternTextPlaceholders
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var none = Placeholders()
    lazy var some = Placeholders(("#", \.isNumber))
    lazy var many = Placeholders(["#": \.isNumber, "@": \.isLetter])
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func AssertSubscriptResults(_ instance: Placeholders,
    _ scenarios: () -> [(Character, Character, Bool?)]) {
        for scenario in scenarios() {
            XCTAssertEqual(instance[scenario.0]?(scenario.1), scenario.2)
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
        Placeholders(("A", { _ in true })),
        Placeholders(("_", { _ in true })))
        
        XCTAssertNotEqual(
        Placeholders(["A": { _ in true }, "B": { _ in true }]),
        Placeholders(["A": { _ in true }, "_": { _ in true }]))
    }
}

#endif
