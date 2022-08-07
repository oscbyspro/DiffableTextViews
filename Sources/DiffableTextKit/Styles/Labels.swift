//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Labels
//*============================================================================*

/// Adds a prefix and/or suffix to another style.
public struct LabelsTextStyle<Base: DiffableTextStyle>: WrapperTextStyle {
    
    public typealias Cache = Base.Cache
    public typealias Value = Base.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var base:   Base
    public var prefix: String
    public var suffix: String
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base, prefix: String, suffix: String) {
        self.base = base; self.prefix = prefix; self.suffix = suffix
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
    
    @inlinable @inline(__always) func label(_ text: inout String) {
        if !prefix.isEmpty { text = prefix + text } /*----*/
        if !suffix.isEmpty { text.append(contentsOf: suffix) }
    }
    
    @inlinable @inline(__always) func label(_ commit: inout Commit<Value>) {
        let anchor = commit.snapshot.anchor

        if !prefix.isEmpty { commit.snapshot = Snapshot(prefix, as: .phantom) + commit.snapshot }
        if !suffix.isEmpty { commit.snapshot.append(contentsOf: suffix, as: .phantom) /*-----*/ }
        
        if !prefix.isEmpty, let anchor {
            var position = commit.snapshot.startIndex
            commit.snapshot.formIndex(&position, offsetBy: prefix.count + anchor.attribute)
            commit.snapshot.anchor(at: position)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conditionals
//=----------------------------------------------------------------------------=

extension LabelsTextStyle: NullableTextStyle where Base: NullableTextStyle { }

//*============================================================================*
// MARK: * Labels x Style
//*============================================================================*

public extension DiffableTextStyle {
    
    typealias Labels = LabelsTextStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Adds a prefix and suffix to the style.
    @inlinable func labels(prefix: String, suffix: String) -> Labels {
        Labels(self, prefix: prefix, suffix: suffix)
    }
    
    /// Adds a prefix to the style.
    @inlinable func prefix(_ prefix: String) -> Labels {
        Labels(self, prefix: prefix, suffix: String())
    }
    
    /// Adds a suffix to the style.
    @inlinable func suffix(_ suffix: String) -> Labels {
        Labels(self, prefix: String(), suffix: suffix)
    }
}
