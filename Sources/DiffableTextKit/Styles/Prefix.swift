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
        var text = base.format(value, with: &cache); label(&text); return text
    }
    
    @inlinable public func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value> {
        var commit = base.interpret(value, with: &cache); label(&commit); return commit
    }
    
    @inlinable public func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value> {
        var commit = try base.resolve(proposal, with: &cache); label(&commit); return commit
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
        let anchor = commit.snapshot.anchor
        
        commit.snapshot = Snapshot(prefix, as: .phantom) + commit.snapshot
        
        guard let anchor else { return }
        commit.snapshot.anchor(at:  commit.snapshot.index(
        commit.snapshot.startIndex, offsetBy: prefix.count + anchor.attribute))
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
