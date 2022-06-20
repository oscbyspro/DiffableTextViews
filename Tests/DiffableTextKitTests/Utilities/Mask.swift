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
// MARK: * Mask x Tests
//*============================================================================*

final class MaskTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCallAsFunctionMask() {
        let max = Options(rawValue: .max)
        XCTAssertEqual(max(  true),  max)
        XCTAssertEqual(max( false),  [ ])
    }
    
    //*========================================================================*
    // MARK: * Elements
    //*========================================================================*
    
    struct Options: OptionSet { let rawValue: UInt8 }
}

#endif
