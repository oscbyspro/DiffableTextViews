//
//  Wrapper.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-29.
//

import Foundation

//*============================================================================*
// MARK: * Wrapper
//*============================================================================*

@usableFromInline protocol Wrapper: DiffableTextStyle where Value == Style.Value {
    
    //=------------------------------------------------------------------------=
    // MARK: Style
    //=------------------------------------------------------------------------=
    
    associatedtype Style: DiffableTextStyle
    
    @inlinable var style: Style { get set }
}

//=----------------------------------------------------------------------------=
// MARK: Wrapper - Details
//=----------------------------------------------------------------------------=

extension Wrapper {
    
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
        lhs.style == rhs.style
    }
}

//*============================================================================*
// MARK: * Wrapper x UIKit
//*============================================================================*

#if canImport(UIKit)

import UIKit

@usableFromInline protocol UIKitWrapper:
Wrapper, UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

//=----------------------------------------------------------------------------=
// MARK: Wrapper x UIKit - Details
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
