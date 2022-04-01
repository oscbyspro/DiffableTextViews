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
public struct EqualsTextStyle<Style: DiffableTextStyle, Proxy: Equatable>: _WrapperTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style
    @usableFromInline let proxy: Proxy

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(_ style: Style, proxy: Proxy) where Proxy: Equatable {
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
        Equals(self, proxy: _Void())
    }
    
    /// Binds the style's comparison result to the proxy value.
    @inlinable @inline(__always)
    public func equals<Proxy>(_ proxy: Proxy) -> Equals<Proxy> {
        Equals(self, proxy: proxy)
    }
}

#if os(iOS)

import DiffableTextViewsXiOS

//*============================================================================*
// MARK: * Equals x iOS
//*============================================================================*

extension EqualsTextStyle: WrapperTextStyle, DiffableTextStyle where Style: DiffableTextStyle { }

#endif
