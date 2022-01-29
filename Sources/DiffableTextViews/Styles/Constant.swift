//
//  Constant.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-28.
//

import Foundation

//*============================================================================*
// MARK: * Constant
//*============================================================================*

public struct Constant<Style: DiffableTextStyle>: Wrapper {
    public typealias ID = AnyHashable
    public typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) init(style: Style) { self.style = style }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public func locale(_ locale: Locale) -> Self { self }
}

//=----------------------------------------------------------------------------=
// MARK: Proxy - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension Constant: UIKitWrapper, UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

#endif

//*============================================================================*
// MARK: * DiffableTextStyle x Proxy
//*============================================================================*

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Prevents changes to this style, such as localization.
    @inlinable func constant() -> Constant<Self> {
        Constant(style: self)
    }
}

