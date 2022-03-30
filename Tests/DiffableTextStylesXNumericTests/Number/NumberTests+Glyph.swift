//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import DiffableTestKit
@testable import DiffableTextStylesXNumeric

//*============================================================================*
// MARK: * NumberTests x Glyph
//*============================================================================*

final class NumberTestsXGlyph: Tests {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let iterations = 1
    let digits = [Digit](repeating: .seven, count: 1)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// 10,000 digits and 10,000 iterations: 10.137 seconds.
    func test_Digits_ForEachUnicodeScalar_String() {
        measure {
            var string = String()
            string.reserveCapacity(digits.count * iterations)
            //=--------------------------------------=
            // MARK: Insert
            //=--------------------------------------=
            for _ in 0 ..< iterations {
                for digit in digits {
                    digit.unicode.write(to: &string)
                }
            }
        }
    }
    
    /// 10,000 digits and 10,000 iterations: 0.030 seconds.
    func test_Digits_UnsafeBitCastToBytes_String() {
        measure {
            var bytes = [UInt8]()
            bytes.reserveCapacity(digits.count * iterations)
            //=--------------------------------------=
            // MARK: Insert
            //=--------------------------------------=
            for _ in 0 ..< iterations {
                bytes.append(contentsOf: unsafeBitCast(digits, to: [UInt8].self))
            }
            //=----------------------------------=
            // MARK: Result
            //=----------------------------------=
            let _ = String(bytes: bytes, encoding: .utf8)
        }
    }
}

#endif
