//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Constant
//*============================================================================*

/// Prevents style transformations.
///
/// Use this style to prevent changes via the environment, for example.
///
public struct ConstantTextStyle<Style: DiffableTextStyle>: WrapperTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(_ style: Style) { self.style = style }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always)
    public func locale(_ locale: Locale) -> Self { return self }
}

//*============================================================================*
// MARK: * Constant x DiffableTextStyle
//*============================================================================*

extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    public typealias Constant = ConstantTextStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Prevents style transformations.
    ///
    /// Use this style to prevent changes via the environment, for example.
    ///
    @inlinable @inline(__always)
    public func constant() -> Constant {
        Constant(self)
    }
}
