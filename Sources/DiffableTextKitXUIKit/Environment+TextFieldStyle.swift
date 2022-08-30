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
// MARK: * Environment x Text Field Style
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Keys
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_TextFieldStyle: EnvironmentKey {
    @usableFromInline static let defaultValue: UITextField.BorderStyle = .none
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    @inlinable var diffableTextViews_textFieldStyle: UITextField.BorderStyle {
        get { self[DiffableTextViews_TextFieldStyle.self] }
        set { self[DiffableTextViews_TextFieldStyle.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    /// Sets the style for diffable text fields within this view.
    ///
    /// It is similar to View/textFieldStyle, but based on UIKit.
    ///
    /// ```
    /// DiffableTextField("Bordered", value: $value, style: style)
    ///     .diffableTextViews_textFieldStyle(.roundedRect)
    /// ```
    ///
    /// **Notes**
    ///
    /// - The value is read when the view is set up.
    /// - The default value is `UITextField.BorderStyle.none`.
    /// - The `View/textFieldStyle` environment value is inaccessible.
    ///
    @inlinable func diffableTextViews_textFieldStyle(_ style: UITextField.BorderStyle) -> some View  {
        self.environment(\.diffableTextViews_textFieldStyle, style)
    }
}

#endif
