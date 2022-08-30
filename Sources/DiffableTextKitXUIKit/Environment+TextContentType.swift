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
// MARK: * Environment x Text Content Type
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Keys
//=----------------------------------------------------------------------------=

@usableFromInline enum DiffableTextViews_TextContentType: EnvironmentKey {
    @usableFromInline static let defaultValue: UITextContentType? = nil
}

//=----------------------------------------------------------------------------=
// MARK: + Values
//=----------------------------------------------------------------------------=

extension EnvironmentValues {
    @inlinable var diffableTextViews_textContentType: UITextContentType? {
        get { self[DiffableTextViews_TextContentType.self] }
        set { self[DiffableTextViews_TextContentType.self] = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + View
//=----------------------------------------------------------------------------=

public extension View {
    
    /// Sets the text content type for diffable text views, which the system uses
    /// to offer suggestions while the user enters text on an iOS or tvOS device.
    ///
    /// It is similar to `View/textContentType(_:)`.
    ///
    /// ```
    /// DiffableTextField("Enter your email", text: $emailAddress)
    ///     .diffableTextViews_textContentTypetextContentType(.emailAddress)
    /// ```
    ///
    /// **Notes**
    ///
    /// - The default value is `UITextContentType?.none`.
    /// - The `View/textContentType(_:)` environment value is inaccessible.
    ///
    @inlinable func diffableTextViews_textContentType(_ type: UITextContentType?) -> some View {
        self.environment(\.diffableTextViews_textContentType, type)
    }
}

#endif
