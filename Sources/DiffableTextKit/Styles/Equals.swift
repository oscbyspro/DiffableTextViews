//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Equals
//*============================================================================*

/// Binds the style's equality to a proxy value.
///
/// Use this modifier to optimize the comparison on view update.
///
@usableFromInline struct Equals<Style: DiffableTextStyle, Proxy: Equatable>: DiffableTextStyleWrapper {
    public typealias Cache = Style.Cache
    public typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var style: Style
    public let proxy: Proxy

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ style: Style, proxy: Proxy) {
        self.style = style
        self.proxy = proxy
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.proxy == rhs.proxy
    }
}

//*============================================================================*
// MARK: * Equals x Style
//*============================================================================*

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Binds the style's equality to a proxy value.
    ///
    /// Use this modifier to optimize the comparison on view update.
    ///
    @inlinable func equals(_ proxy: Void) -> some DiffableTextStyle<Value> {
        Equals(self, proxy: _Void())
    }
    
    /// Binds the style's equality to a proxy value.
    ///
    /// Use this modifier to optimize the comparison on view update.
    ///
    @inlinable func equals(_ proxy: some Equatable) -> some DiffableTextStyle<Value> {
        Equals(self, proxy:  proxy)
    }
}
