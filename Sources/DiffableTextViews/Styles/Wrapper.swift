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

@usableFromInline protocol Wrapper: DiffableTextStyle where Value == Style.Value {
    
    //=------------------------------------------------------------------------=
    // MARK: Style
    //=------------------------------------------------------------------------=
    
    associatedtype Style: DiffableTextStyle
    
    @inlinable var style: Style { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func make(style: Style) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: Wrapper
//=----------------------------------------------------------------------------=

extension Wrapper {
    
    //=------------------------------------------------------------------------=
    // MARK: Locale
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public func locale(_ locale: Locale) -> Self {
        make(style: style.locale(locale))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public func showcase(value: Value) -> String {
        style.showcase(value: value)
    }
    
    @inlinable @inline(__always) public func editable(value: Value) -> Commit<Value> {
        style.editable(value: value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public func merge(request: Request) throws -> Commit<Value> {
        try style.merge(request: request)
    }
}
