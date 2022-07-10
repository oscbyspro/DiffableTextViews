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
// MARK: * Comments x Percent
//*============================================================================*

final class CommentsOnPercent: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testPercentLabelsAreAlwaysVirtual() throws {
        //=--------------------------------------=
        // Locales
        //=--------------------------------------=
        for scheme in standards {
            func nonvirtual(_ character: Character) -> Bool {
                   scheme.reader.components.signs[     character] != nil
                || scheme.reader.components.digits[    character] != nil
                || scheme.reader.components.separators[character] == Separator.fraction
            }
            
            let zero = IntegerFormatStyle<Int>.Percent(locale: scheme.id.locale).format(0)
            XCTAssert(zero.count(where: nonvirtual) == 1,  "\(zero), \(scheme.id.locale)")
        }
    }
}

#endif
