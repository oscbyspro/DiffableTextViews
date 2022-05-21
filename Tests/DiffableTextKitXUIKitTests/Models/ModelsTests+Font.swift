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

@testable import DiffableTextKitXUIKit

import XCTest

//*============================================================================*
// MARK: * Models x Font
//*============================================================================*

final class ModelsTestsXFont: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var fonts: [DiffableTextFont] = {
        var fonts = [DiffableTextFont]()
        #if !os(tvOS)
        fonts.append(.largeTitle)
        #endif
        fonts.append(.title1)
        fonts.append(.title2)
        fonts.append(.title3)
        fonts.append(.headline)
        fonts.append(.subheadline)
        fonts.append(.body)
        fonts.append(.footnote)
        fonts.append(.caption1)
        fonts.append(.caption2)
        return fonts
    }()
    
    lazy var designs: [UIFontDescriptor.SystemDesign] = [
        .default, .monospaced, .rounded, .serif
    ]

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDesignsCanBeForceUnwrapped() {
        //=--------------------------------------=
        // Fonts, Designs
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
