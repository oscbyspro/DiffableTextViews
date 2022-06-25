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
    typealias T = Placeholders
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var none = T()
    lazy var some = T(("#", \.isNumber))
    lazy var many = T(["#": \.isNumber, "@": \.isLetter])
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    func TRUE(_ character: Character) -> Bool {  true }
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func AssertStorageResult(_ instance: T, _ value: Int) {
        switch instance.storage {
        case .none: XCTAssertEqual(value, 0)
        case .some: XCTAssertEqual(value, 1)
        case .many: XCTAssertEqual(value, 2)
        }
    }
    
    func AssertSubscriptResults(_ instance: T, _ values: () -> [(Character, Character, Bool?)]) {
        for value in values() {
            XCTAssertEqual(instance[value.0]?(value.1), value.2)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x State
    //=------------------------------------------------------------------------=
    
    func testNoneSomeManyStorage() {
        AssertStorageResult(none, 0)
        AssertStorageResult(some, 1)
        AssertStorageResult(many, 2)
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
        T(("A", TRUE)),
        T(("_", TRUE)))
        
        XCTAssertNotEqual(
        T(["A": TRUE, "B": TRUE]),
        T(["A": TRUE, "_": TRUE]))
    }
}

#endif
