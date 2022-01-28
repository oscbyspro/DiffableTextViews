//
//  Constant.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-28.
//

//*============================================================================*
// MARK: * Constant
//*============================================================================*

public struct Constant<Style: DiffableTextStyle>: Wrapper {
    public typealias Value = Style.Value

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    public var style: Style

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) init(style: Style) {
        self.style = style
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public static func == (lhs: Self, rhs: Self) -> Bool { true }
}

//=----------------------------------------------------------------------------=
// MARK: Constant - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension Constant: UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

#endif

//*============================================================================*
// MARK: * DiffableTextStyle x Constant
//*============================================================================*

extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func constant() -> Constant<Self> {
        Constant(style: self)
    }
}

