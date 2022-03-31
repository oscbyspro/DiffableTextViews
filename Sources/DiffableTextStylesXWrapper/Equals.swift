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

/// A style that equals a proxy value.
///
/// Use this style to optimize the comparison on view update.
///
public struct EqualsTextStyle<Style: DiffableTextStyle, Proxy: Equatable>: WrapperTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let proxy: Proxy
    @usableFromInline var style: Style
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(style: Style, proxy: Proxy) where Proxy: Equatable {
        self.style = style
        self.proxy = proxy
    }

    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.proxy == rhs.proxy
    }
}

#if os(iOS)

import DiffableTextViewsXiOS

//*============================================================================*
// MARK: * Equals x iOS
//*============================================================================*

extension EqualsTextStyle: WrapperTextStyleXiOS, DiffableTextStyleXiOS where Style: DiffableTextStyleXiOS { }

#endif

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
    
    /// Binds the style's comparison result to the proxy value.
    @inlinable @inline(__always)
    public func equals(_ proxy: Void) -> Equals<_Void> {
        Equals(style: self, proxy: _Void())
    }
    
    /// Binds the style's comparison result to the proxy value.
    @inlinable @inline(__always)
    public func equals<Proxy>(_ proxy: Proxy) -> Equals<Proxy> {
        Equals(style: self, proxy: proxy)
    }
}
