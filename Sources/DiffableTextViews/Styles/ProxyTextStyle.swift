//
//  ProxyTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-29.
//

import SwiftUI
import Support

//*============================================================================*
// MARK: * ProxyTextStyle
//*============================================================================*

/// A style that binds equals a specific value.
///
/// Use this style to optimize the differentiation on view update.
///
public struct ProxyTextStyle<Style: DiffableTextStyle, Proxy: Equatable>: WrapperTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style
    @usableFromInline let proxy: Proxy
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(style: Style, proxy: Proxy) {
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

//=----------------------------------------------------------------------------=
// MARK: ProxyTextStyle - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension ProxyTextStyle: UIKitWrapper, UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

#endif

//*============================================================================*
// MARK: * DiffableTextStyle x ProxyTextStyle
//*============================================================================*

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Binds the style's differentiation result to a constant.
    @inlinable func constant() -> ProxyTextStyle<Self, Constant> {
        ProxyTextStyle(style: self, proxy: Constant())
    }
    
    /// Binds the style's differentiation result to the value.
    @inlinable func equals<Proxy: Equatable>(_ value: Proxy) -> ProxyTextStyle<Self, Proxy> {
        ProxyTextStyle(style: self, proxy: value)
    }
}
