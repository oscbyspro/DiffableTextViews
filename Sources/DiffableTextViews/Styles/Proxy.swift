//
//  Proxy.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-29.
//

//*============================================================================*
// MARK: * Proxy
//*============================================================================*

public struct Proxy<Style: DiffableTextStyle>: Wrapper {
    public typealias ID = AnyHashable
    public typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let id: ID
    @usableFromInline var style: Style
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) init(style: Style, id: ID) {
        self.id = id
        self.style = style
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
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
    
    /// Binds the style's identity to the value: zero.
    @inlinable func constantID() -> Proxy<Self> {
        Proxy(style: self, id: 00)
    }
    
    /// Binds the style's identity to the value.
    @inlinable func id<ID: Hashable>(_ id: ID) -> Proxy<Self> {
        Proxy(style: self, id: id)
    }
}
