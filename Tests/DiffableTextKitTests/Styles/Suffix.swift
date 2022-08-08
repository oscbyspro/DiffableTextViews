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
// MARK: * Suffix x Tests
//*============================================================================*

final class SuffixTests: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func OK(value: String, suffix: String, format: String) {
        let style = Mock().suffix(suffix); XCTAssertEqual(style.format(value), format)
    }
    
    func OK(value: String, suffix: String, interpret: Commit<String>) {
        let style = Mock().suffix(suffix); XCTAssertEqual(style.interpret(value), interpret)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func test() {
        OK(value: "🇸🇪", suffix: "🇺🇸", format: "🇸🇪🇺🇸")
        OK(value: "🇸🇪", suffix: "🇺🇸", interpret: Commit("🇸🇪", "🇸🇪" + Snapshot("🇺🇸", as: .phantom)))
    }
}

#endif
