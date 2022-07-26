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
/// Use this modifier to ignore the environment.
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
    
    @inlinable init(_ style: Style) { self.style = style }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable public func locale(_ locale: Locale) -> Self { self }
}

//*============================================================================*
// MARK: * Constant x Style
//*============================================================================*

public extension DiffableTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Prevents style transformations.
    ///
    /// Use this modifier to ignore the environment.
    ///
    @inlinable func constant() -> some DiffableTextStyle<Value> {
        Constant(self)
    }
}
