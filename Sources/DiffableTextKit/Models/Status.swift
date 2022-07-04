//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Status
//*===========================================================================

/// A model used to collect upstream and downstream values.
public struct Status<Style: DiffableTextStyle>: Equatable, Transformable {
    public typealias Value = Style.Value
    public typealias Cache = Style.Cache
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var style: Style
    public var value: Value
    public var focus: Focus

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ style: Style, _ value: Value, _ focus: Focus) {
        self.style = style
        self.value = value
        self.focus = focus
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Merges member-wise inequalities.
    @inlinable public mutating func merge(_ other: Self) -> Changes {
        let changes = (self .!= other)
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        if changes.contains(.style) { self.style = other.style }
        if changes.contains(.value) { self.value = other.value }
        if changes.contains(.focus) { self.focus = other.focus }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return changes
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(with cache: inout Cache) -> String {
        style.update(&cache); return style.format(value, with: &cache)
    }
    
    @inlinable func interpret(with cache: inout Cache) -> Commit<Style.Value> {
        style.update(&cache); return style.interpret(value, with: &cache)
    }
    
    @inlinable func resolve(_  proposal: Proposal, with
    cache: inout Cache) throws -> Commit<Style.Value> {
        style.update(&cache); return try style.resolve(proposal, with: &cache)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func .!= (lhs: Self, rhs: Self) -> Changes {[
        .style(lhs.style != rhs.style),
        .value(lhs.value != rhs.value),
        .focus(lhs.focus != rhs.focus),
    ]}
}
