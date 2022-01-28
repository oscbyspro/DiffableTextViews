//
//  Wrapper.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-28.
//

import Foundation

//*============================================================================*
// MARK: * Wrapper
//*============================================================================*

public protocol Wrapper: DiffableTextStyle where Value == Style.Value {
    
    //=------------------------------------------------------------------------=
    // MARK: Style
    //=------------------------------------------------------------------------=
    
    associatedtype Style: DiffableTextStyle
    
    @inlinable var style: Style { get set }
}

//=----------------------------------------------------------------------------=
// MARK: Wrapper
//=----------------------------------------------------------------------------=

public extension Wrapper {
    
    //=------------------------------------------------------------------------=
    // MARK: Locale
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func locale(_ locale: Locale) -> Self {
        var result = self; result.style = style.locale(locale); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func showcase(value: Value) -> String {
        style.showcase(value: value)
    }
    
    @inlinable @inline(__always) func editable(value: Value) -> Commit<Value> {
        style.editable(value: value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func merge(request: Request) throws -> Commit<Value> {
        try style.merge(request: request)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Wrapper - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension Wrapper where Self: UIKitDiffableTextStyle, Style: UIKitDiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public static func setup(diffableTextField: ProxyTextField) {
        Style.setup(diffableTextField: diffableTextField)
    }
}

#endif
