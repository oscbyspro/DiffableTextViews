//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG
#if canImport(UIKit)

import DiffableTestKit
@testable import DiffableTextKitXUIKit

//*============================================================================*
// MARK: * ModelsTests x Font
//*============================================================================*

final class ModelsTestsXFont: Tests {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    #if os(tvOS)
    let fonts: [DiffableTextFont] = [
        .title1,
        .title2,
        .title3,
        .headline,
        .subheadline,
        .body,
        .callout,
        .footnote,
        .caption1,
        .caption2,
    ]
    #else
    let fonts: [DiffableTextFont] = [
        .largeTitle,
        .title1,
        .title2,
        .title3,
        .headline,
        .subheadline,
        .body,
        .callout,
        .footnote,
        .caption1,
        .caption2,
    ]
    #endif
    
    lazy var designs: [UIFontDescriptor.SystemDesign] = [
        .default, .monospaced, .rounded, .serif
    ]

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDesignsCanBeForceUnwrapped() {
        //=--------------------------------------=
        // MARK: Fonts, Designs
        //=--------------------------------------=
        for font in fonts {
            for design in designs {
                XCTAssertNotNil(font.descriptor.withDesign(design))
            }
        }
    }
}

#endif
#endif
