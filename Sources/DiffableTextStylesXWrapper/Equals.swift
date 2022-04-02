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

/// A style that binds its comparison to a proxy value.
///
/// Use this wrapper to optimize the comparison on view update.
///
/// - Note: DiffableTextView updates its style only when the proposed style is inequal.
///
public struct EqualsTextStyle<Style: DiffableTextStyle, Proxy: Equatable>: WrapperTextStyle {
    
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
    
    public typealias EqualsVoid = EqualsTextStyle<Self, _Void>
    public typealias Equals<Proxy: Equatable> = EqualsTextStyle<Self, Proxy>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Binds the style's comparison to a proxy value.
    ///
    /// Use this wrapper to optimize the comparison on view update.
    ///
    /// - Note: DiffableTextView updates its style only when the proposed style is inequal.
    ///
    @inlinable @inline(__always)
    public func equals(_ proxy: Void) -> EqualsVoid {
        Equals(self, proxy: _Void())
    }
    
    /// Binds the style's comparison to a proxy value.
    ///
    /// Use this wrapper to optimize the comparison on view update.
    ///
    /// - Note: DiffableTextView updates its style only when the proposed style is inequal.
    ///
    @inlinable @inline(__always)
    public func equals<Proxy>(_ proxy: Proxy) -> Equals<Proxy> {
        Equals(self, proxy: proxy)
    }
}
