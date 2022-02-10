//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI

//*============================================================================*
// MARK: * DiffableTextStyle x Cache
//*============================================================================*

/// A reference type wrapper text style.
///
/// Use this style when want to store it as a reference value.
///
public final class CacheTextStyle<Style: DiffableTextStyle>: WrapperTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) init(style: Style) { self.style = style }
}

#if canImport(UIKit)

//*============================================================================*
// MARK: * DiffableTextStyle x Cache x UIKit
//*============================================================================*

extension CacheTextStyle: UIKitWrapperTextStyle, UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

#endif

//*============================================================================*
// MARK: * DiffableTextStyle x Cache
//*============================================================================*

extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    public typealias Cache = CacheTextStyle<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Wraps the text style in a reference type.
    @inlinable public func storable() -> CacheTextStyle<Self> {
        CacheTextStyle(style: self)
    }
}
