//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Prefix
//*============================================================================*

/// Adds a prefix to another style.
public struct PrefixTextStyle<Base: DiffableTextStyle>: WrapperTextStyle {
    
    public typealias Cache = Base.Cache
    public typealias Value = Base.Value
    
    @usableFromInline typealias Characters = Offset<Character>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var base:   Base
    public var prefix: String
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base, prefix: String) {
        self.base = base;  self.prefix = prefix
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable public func format(_ value: Value, with cache: inout Cache) -> String {
        var S0 = base.format(value, with: &cache); label(&S0); return S0
    }
    
    @inlinable public func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value> {
        var S0 = base.interpret(value, with: &cache); label(&S0); return S0
    }
    
    @inlinable public func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value> {
        var S0 = try base.resolve(proposal, with: &cache); label(&S0); return S0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func label(_ text: inout String) {
        guard !prefix.isEmpty else { return }
        text = prefix + text
    }
    
    @inlinable func label(_ commit: inout Commit<Value>) {
        guard !prefix.isEmpty else { return }
        let selection = commit.snapshot.selection
        
        commit.snapshot = Snapshot(prefix, as: .phantom) + commit.snapshot
        
        guard let selection else { return }
        let offsets = selection.map({ Characters(prefix.count + $0.attribute) })
        commit.snapshot.select(commit.snapshot.indices(at: offsets.positions()))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conditionals
//=----------------------------------------------------------------------------=

extension PrefixTextStyle: NullableTextStyle where Base: NullableTextStyle { }

//*============================================================================*
// MARK: * Prefix x Style
//*============================================================================*

public extension DiffableTextStyle {
    
    typealias Prefix = PrefixTextStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Adds a prefix to the style.
    @inlinable func prefix(_ prefix: String) -> Prefix {
        Prefix(self, prefix: prefix)
    }
}
