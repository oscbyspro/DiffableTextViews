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
public struct EqualsTextStyle<Base, Equatable>: WrapperTextStyle
where Base: DiffableTextStyle, Equatable: Swift.Equatable {
    
    public typealias Cache = Base.Cache
    public typealias Value = Base.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var base: Base
    public var equatable: Equatable

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base, equatable: Equatable) {
        self.base = base; self.equatable = equatable
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.equatable == rhs.equatable
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conditionals
//=----------------------------------------------------------------------------=

extension EqualsTextStyle: NullableTextStyle where Base: NullableTextStyle { }

//*============================================================================*
// MARK: * Equals x Style
//*============================================================================*

public extension DiffableTextStyle {
    
    typealias Equals<T> = EqualsTextStyle<Self, T> where T: Equatable
    
    typealias EqualsVoid = EqualsTextStyle<Self, _Void>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Binds the style's equality to a proxy value.
    ///
    /// Use this modifier to optimize the comparison on view update.
    ///
    @inlinable func equals<T>(_ equatable: T) -> Equals<T> {
        Equals(self, equatable: equatable)
    }
    
    /// Binds the style's equality to a proxy value.
    ///
    /// Use this modifier to optimize the comparison on view update.
    ///
    @inlinable func equals(_ equatable: Void) -> EqualsVoid {
        Equals(self, equatable: _Void())
    }
}
