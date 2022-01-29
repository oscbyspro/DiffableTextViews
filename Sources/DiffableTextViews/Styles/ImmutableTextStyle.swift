//
//  ImmutableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-28.
//

import Foundation

//*============================================================================*
// MARK: * ImmutableTextStyle
//*============================================================================*

/// A style that prevents changes.
///
/// Use this style if you do not want its content to be overriden by the environment.
///
public struct ImmutableTextStyle<Style: DiffableTextStyle>: WrapperTextStyle {
    public typealias ID = AnyHashable
    public typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(style: Style) { self.style = style }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func locale(_ locale: Locale) -> Self { self }
}

//=----------------------------------------------------------------------------=
// MARK: Proxy - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension ImmutableTextStyle: UIKitWrapper, UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

#endif

//*============================================================================*
// MARK: * DiffableTextStyle x Proxy
//*============================================================================*

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Prevents changes to this style, such as localization.
    @inlinable func immutable() -> ImmutableTextStyle<Self> {
        ImmutableTextStyle(style: self)
    }
}

