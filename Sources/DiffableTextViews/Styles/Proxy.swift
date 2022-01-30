//
//  Proxy.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-29.
//

import SwiftUI
import Support

//*============================================================================*
// MARK: * Proxy
//*============================================================================*

/// A style that binds equals a specific value.
///
/// Use this style to optimize the differentiation on view update.
///
public struct Proxy<Style: DiffableTextStyle, ID: Equatable>: Wrapper {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let value: ID
    @usableFromInline var style: Style
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(style: Style, value: ID) {
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

//=----------------------------------------------------------------------------=
// MARK: Proxy - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension Proxy: UIKitWrapper, UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

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
    
    /// Binds the style's differentiation result to the value.
    @inlinable func equals<Value: Equatable>(_ value: Value) -> Proxy<Self, Value> {
        Proxy(style: self, value: value)
    }
}
