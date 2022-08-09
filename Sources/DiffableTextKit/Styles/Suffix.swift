//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Suffix
//*============================================================================*

/// Adds a suffix to another style.
public struct SuffixTextStyle<Base: DiffableTextStyle>: WrapperTextStyle {
    
    public typealias Cache = Base.Cache
    public typealias Value = Base.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var base:   Base
    public var suffix: String
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base, suffix: String) {
        self.base = base;  self.suffix = suffix
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable public func format(_ value: Value, with cache: inout Cache) -> String {
        var S0 = base.format(value, with: &cache); label(&S0); return S0
    }
    
    @inlinable public func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value> {
        var S0 = base.interpret(value, with: &cache); label(&S0.snapshot); return S0
    }
    
    @inlinable public func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value> {
        var S0 = try base.resolve(proposal, with: &cache); label(&S0.snapshot); return S0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func label(_ text: inout String) {
        text.append(contentsOf: suffix)
    }
    
    @inlinable func label(_ snapshot: inout Snapshot) {
        snapshot.append(contentsOf: suffix, as: .phantom)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conditionals
//=----------------------------------------------------------------------------=

extension SuffixTextStyle: NullableTextStyle where Base: NullableTextStyle { }

//*============================================================================*
// MARK: * Suffix x Style
//*============================================================================*

public extension DiffableTextStyle {
    
    typealias Suffix = SuffixTextStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Adds a suffix to the style.
    @inlinable func suffix(_ suffix: String) -> Suffix {
        Suffix(self, suffix: suffix)
    }
}
