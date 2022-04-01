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


/// A style that returns an unmodified self for standard transformations.
///
/// Use this style to prevent changes via the environment, for example.
///
public struct ConstantTextStyle<Style: _DiffableTextStyle>: _WrapperTextStyle {
    
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

#if os(iOS)

import DiffableTextViewsXiOS

//*============================================================================*
// MARK: * Constant x iOS
//*============================================================================*

extension ConstantTextStyle: WrapperTextStyle, DiffableTextStyle where Style: DiffableTextStyle { }

#endif

//*============================================================================*
// MARK: * Constant x DiffableTextStyle
//*============================================================================*

extension _DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    public typealias Constant = ConstantTextStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// A style that returns an unmodified self for standard transformations.
    ///
    /// Use this style to prevent changes via the environment, for example.
    ///
    @inlinable @inline(__always)
    public func constant() -> Constant {
        Constant(self)
    }
}
