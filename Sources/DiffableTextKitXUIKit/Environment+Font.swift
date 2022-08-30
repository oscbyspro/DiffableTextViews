//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import SwiftUI

//*============================================================================*
// MARK: * Environment x Font
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Keys
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_Font: EnvironmentKey {
    @usableFromInline static let defaultValue: DiffableTextFont? = nil
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    @inlinable var diffableTextViews_font: DiffableTextFont? {
        get { self[DiffableTextViews_Font.self] }
        set { self[DiffableTextViews_Font.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    /// Sets the font for diffable text views.
    ///
    /// It is similar to `View/font(_:)` but uses a SwiftUI-esque system font type.
    ///
    /// ```
    /// DiffableTextField("Monospaced", value: $value, style: style)
    ///     .diffableTextViews_font(.body.monospaced())
    /// ```
    ///
    /// Monospaced fonts are recommended because they make as-you-type formatting
    /// more visually predictable. Sometimes it does not matter much, however. As-
    /// you-type formatting with trailing text alignment works fine with any font,
    /// because the caret and/or selection does not jump around as much.
    ///
    /// **Notes**
    ///
    /// - The default value is `DiffableTextFont.body`.
    /// - It is not yet possible to convert `SwiftUI.Font` to `UIKit.UIFont`.
    ///
    @inlinable func diffableTextViews_font(_ font: DiffableTextFont?) -> some View {
        self.environment(\.diffableTextViews_font, font)
    }
}

#endif
