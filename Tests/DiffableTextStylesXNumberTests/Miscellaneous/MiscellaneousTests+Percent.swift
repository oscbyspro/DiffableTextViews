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
@testable import DiffableTextStylesXNumber

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class MiscellaneousTestsXPercent: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testPercentLabelsAreAlwaysVirtual() throws {
        //=--------------------------------------=
        // Locales
        //=--------------------------------------=
        for scheme in standards {
            let zero = IntegerFormatStyle<Int>.Percent(locale: scheme.id.locale).format(0)
            XCTAssert(zero.count(where: scheme.lexicon.nonvirtual) == 1, "\(zero), \(scheme.id.locale)")
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Lexicon
//=----------------------------------------------------------------------------=

fileprivate extension Lexicon {
        
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Used by unit tests.
    func nonvirtual(_ character: Character) -> Bool {
        signs[character] != nil
        || digits[character] != nil
        || separators[character] == .fraction
    }
}

#endif
