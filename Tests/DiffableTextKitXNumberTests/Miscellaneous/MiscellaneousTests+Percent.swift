//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKitXNumber

import XCTest

//*============================================================================*
// MARK: * Miscellaneous x Percent
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
            let components = scheme.reader.components
            let zero = IntegerFormatStyle<Int>.Percent(locale: scheme.id.locale).format(0)
            XCTAssert(zero.count(where: components.nonvirtual) == 1, "\(zero), \(scheme.id.locale)")
        }
    }
}

//*============================================================================*
// MARK: * Components
//*============================================================================*

fileprivate extension Components {
        
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func nonvirtual(_ character: Character) -> Bool {
        signs[character] != nil
        || digits[character] != nil
        || separators[character] == .fraction
    }
}

#endif
