//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Wrapper
//*============================================================================*

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
        var result = self; result.style = result.style.locale(locale); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream - Inactive
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func format(_ value: Style.Value) -> String {
        style.format(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream - Active
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func interpret(_ value: Style.Value) -> Commit<Style.Value> {
        style.interpret(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream - Interactive
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

//*============================================================================*
// MARK: Wrapper x iOS
//*============================================================================*

#if os(iOS)

import DiffableTextViewsXiOS

@usableFromInline protocol WrapperTextStyleXiOS:
WrapperTextStyle,
DiffableTextStyleXiOS where
Style: DiffableTextStyleXiOS { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension WrapperTextStyleXiOS {
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func onSetup(_ diffableTextField: ProxyTextField) {
        Style.onSetup(diffableTextField)
    }
}

#endif
