//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI

//*============================================================================*
// MARK: * DiffableTextStyle x Wrapper
//*============================================================================*

/// A style that equals a specific value.
///
/// Use this style to optimize the differentiation on view update.
///
@usableFromInline protocol WrapperTextStyle: DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Style
    //=------------------------------------------------------------------------=
    
    associatedtype Style: DiffableTextStyle

    @inlinable var style: Style { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension WrapperTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func locale(_ locale: Locale) -> Self {
        var result = self; result.style = style.locale(locale); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func format(_ value: Style.Value) -> String {
        style.format(value)
    }
    
    @inlinable @inline(__always)
    public func interpret(_ value: Style.Value) -> Commit<Style.Value> {
        style.interpret(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func merge(_ changes: Changes) throws -> Commit<Style.Value> {
        try style.merge(changes)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.style == rhs.style
    }
}

#if canImport(UIKit)

//*============================================================================*
// MARK: DiffableTextStyle x Wrapper x UIKit
//*============================================================================*

@usableFromInline protocol UIKitWrapperTextStyle:
WrapperTextStyle, UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension UIKitWrapperTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func onSetup(_ diffableTextField: ProxyTextField) {
        Style.onSetup(diffableTextField)
    }
}

#endif