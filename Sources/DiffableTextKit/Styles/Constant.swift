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
public struct ConstantTextStyle<Base: DiffableTextStyle>: WrapperTextStyle {
    public typealias Cache = Base.Cache
    public typealias Value = Base.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var base: Base
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base) { self.base = base }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable public func locale(_ locale: Locale) -> Self { self }
}

//=----------------------------------------------------------------------------=
// MARK: + Conditionals
//=----------------------------------------------------------------------------=

extension ConstantTextStyle: NullableTextStyle where Base: NullableTextStyle { }

//*============================================================================*
// MARK: * Constant x Style
//*============================================================================*

public extension DiffableTextStyle {
    
    typealias Constant = ConstantTextStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Prevents style transformations.
    ///
    /// Use this modifier to ignore the environment.
    ///
    @inlinable func constant() -> Constant {
        Constant(self)
    }
}
