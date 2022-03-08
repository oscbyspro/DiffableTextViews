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
// MARK: * Constant
//*============================================================================*

/// A constant style that equals every other instance of its type.
///
/// Use this style to optimize the differentiation on view update.
///
/// - Note: DiffableTextStyle transformation methods return immediately.
///
public struct ConstantTextStyle<Style: DiffableTextStyle>: WrapperTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(style: Style) { self.style = style }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always)
    public func locale(_ locale: Locale) -> Self { return self }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func == (lhs: Self, rhs: Self) -> Bool { true }
}

//*============================================================================*
// MARK: * Constant x DiffableTextStyle
//*============================================================================*

extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    public typealias Constant = ConstantTextStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Binds the style's differentiation result to a constant and prevents changes to it.
    @inlinable public func constant() -> ConstantTextStyle<Self> {
        ConstantTextStyle(style: self)
    }
}

//*============================================================================*
// MARK: * Constant x iOS
//*============================================================================*

#if canImport(UIKit)

import DiffableTextViewsXiOS

extension ConstantTextStyle:
WrapperTextStyleXiOS,
DiffableTextStyleXiOS where
Style: DiffableTextStyleXiOS { }

#endif

