//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Constant
//*============================================================================*

/// Prevents style transformations.
///
/// Use this style to prevent changes via the environment, for example.
///
@usableFromInline struct Constant<Style: DiffableTextStyle>: DiffableTextStyleWrapper {
    public typealias Cache = Style.Cache
    public typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var style: Style
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(_ style: Style) {
        self.style = style
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always)
    public func locale(_ locale: Locale) -> Self { self }
}

//*============================================================================*
// MARK: * Constant x Style
//*============================================================================*

extension DiffableTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Prevents style transformations.
    ///
    /// Use this style to prevent changes via the environment, for example.
    ///
    @inlinable @inline(__always)
    public func constant() -> some DiffableTextStyle<Value> {
        Constant(self)
    }
}
