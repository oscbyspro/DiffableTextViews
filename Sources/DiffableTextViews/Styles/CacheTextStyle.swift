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
public final class CacheTextStyle<Style: DiffableTextStyle>: DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: State
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
    public func locale(_ locale: Locale) -> Self {
        style = style.locale(locale); return self
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
    public static func == (lhs: CacheTextStyle<Style>, rhs: CacheTextStyle<Style>) -> Bool {
        lhs.style == rhs.style
    }
}

//=----------------------------------------------------------------------------=
// MARK: Proxy - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension CacheTextStyle: UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

#endif

//*============================================================================*
// MARK: * DiffableTextStyle x Proxy
//*============================================================================*

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Wraps the text style in a reference type.
    @inlinable func storable() -> CacheTextStyle<Self> {
        CacheTextStyle(style: self)
    }
}
