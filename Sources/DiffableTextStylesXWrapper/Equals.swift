//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Equals
//*============================================================================*

/// A style that equals a specific value.
///
/// Use this style to optimize the differentiation on view update.
///
public struct EqualsTextStyle<Style: DiffableTextStyle, ID: Equatable>: WrapperTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let value: ID
    @usableFromInline var style: Style
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(style: Style, value: ID) where ID: Equatable {
        self.style = style
        self.value = value
    }

    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

//*============================================================================*
// MARK: * Equals x DiffableTextStyle
//*============================================================================*

extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    public typealias Equals<Value: Equatable> = EqualsTextStyle<Self, Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Binds the style's differentiation result to a value.
    @inlinable public func equals<Value: Equatable>(_ value: Value) -> EqualsTextStyle<Self, Value> {
        EqualsTextStyle(style: self, value: value)
    }
}

//*============================================================================*
// MARK: * Equals x iOS
//*============================================================================*

#if os(iOS)

import DiffableTextViewsXiOS

extension EqualsTextStyle:
WrapperTextStyleXiOS,
DiffableTextStyleXiOS where
Style: DiffableTextStyleXiOS { }

#endif
