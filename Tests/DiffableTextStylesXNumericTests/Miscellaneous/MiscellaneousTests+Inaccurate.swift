//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import XCTest

//*============================================================================*
// MARK: * MiscellaneousTests x Inaccurate
//*============================================================================*

final class MiscellaneousTestsXInaccurate: XCTestCase {
        
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssert<T: BinaryFloatingPoint>(_ value: T, result: String) {
        let style = FloatingPointFormatStyle<T>(locale: en_US)
        XCTAssertEqual(style.precision(.fractionLength(0...)).format(value), result)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFloat16IsInaccurate() {
        XCTAssert(-1.23 as Float16, result: "-1.23046875")
    }
    
    func testFloat32IsInaccurate() {
        XCTAssert(-1.23 as Float32, result: "-1.2300000190734863")
    }
}

#endif
