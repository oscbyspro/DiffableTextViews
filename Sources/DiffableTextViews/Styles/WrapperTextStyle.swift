//
//  WrapperTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-29.
//

import Foundation

//*============================================================================*
// MARK: * WrapperTextStyle
//*============================================================================*

@usableFromInline protocol WrapperTextStyle: DiffableTextStyle where Value == Style.Value {
    
    //=------------------------------------------------------------------------=
    // MARK: Style
    //=------------------------------------------------------------------------=
    
    associatedtype Style: DiffableTextStyle
    
    @inlinable var style: Style { get set }
}

//=----------------------------------------------------------------------------=
// MARK: WrapperTextStyle - Details
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
    public func showcase(value: Style.Value) -> String {
        style.showcase(value: value)
    }
    
    @inlinable @inline(__always)
    public func editable(value: Style.Value) -> Commit<Style.Value> {
        style.editable(value: value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func merge(request: Request) throws -> Commit<Style.Value> {
        try style.merge(request: request)
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
// MARK: * WrapperTextStyle x UIKit
//*============================================================================*

#if canImport(UIKit)

import UIKit

@usableFromInline protocol UIKitWrapper:
WrapperTextStyle, UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

//=----------------------------------------------------------------------------=
// MARK: WrapperTextStyle x UIKit - Details
//=----------------------------------------------------------------------------=

extension UIKitWrapper {
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func onSetup(_ diffableTextField: ProxyTextField) {
        Style.onSetup(diffableTextField)
    }
}

#endif
