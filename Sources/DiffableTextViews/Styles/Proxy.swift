//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import Support

//*============================================================================*
// MARK: * Proxy
//*============================================================================*

/// A style that equals a specific value.
///
/// Use this style to optimize the differentiation on view update.
///
public struct Proxy<Style: DiffableTextStyle, ID: Equatable>: DiffableTextStyle {
    
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
    public func format(value: Style.Value) -> String {
        style.format(value: value)
    }
    
    @inlinable @inline(__always)
    public func commit(value: Style.Value) -> Commit<Style.Value> {
        style.commit(value: value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func merge(changes: Changes) throws -> Commit<Style.Value> {
        try style.merge(changes: changes)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

//=----------------------------------------------------------------------------=
// MARK: Proxy - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension Proxy: UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

#endif

//*============================================================================*
// MARK: * DiffableTextStyle x Proxy
//*============================================================================*

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Binds the style's differentiation result to a constant.
    @inlinable func constant() -> Proxy<Self, Constant> {
        Proxy(style: self, value: Constant())
    }
    
    /// Binds the style's differentiation result to a value.
    @inlinable func equals<Value: Equatable>(_ value: Value) -> Proxy<Self, Value> {
        Proxy(style: self, value: value)
    }
}
