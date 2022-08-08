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
// MARK: * Prefix x Tests
//*============================================================================*

final class PrefixTests: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func OK(prefix: String, value: String, format: String) {
        let style = Mock().prefix(prefix); XCTAssertEqual(style.format(value), format)
    }
    
    func OK(prefix: String, value: String, interpret: Commit<String>) {
        let style = Mock().prefix(prefix); XCTAssertEqual(style.interpret(value), interpret)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func test() {
        OK(prefix: "🇸🇪", value: "🇺🇸", format: "🇸🇪🇺🇸")
        OK(prefix: "🇸🇪", value: "🇺🇸", interpret: Commit("🇺🇸", Snapshot("🇸🇪", as: .phantom) + "🇺🇸"))
    }
}

#endif
