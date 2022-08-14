//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Normal
//*============================================================================*

/// A normal text style, without bells and whistles.
public struct NormalTextStyle: DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public init() {  }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public func format(_ value: String, with cache: inout Void) -> String {
        value
    }
    
    @inlinable public func interpret(_ value: String, with cache: inout Void) -> Commit<String> {
        Commit(value, Snapshot(value))
    }
    
    @inlinable public func resolve(_ proposal: Proposal, with cache: inout Void) throws -> Commit<String> {
        let S0 = Snapshot(proposal.lazy.merged().nonvirtuals()); return Commit(S0.characters, S0)
    }
}

//*============================================================================*
// MARK: * Normal x Init
//*============================================================================*

extension DiffableTextStyle where Self == NormalTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// A normal text style, without bells and whistles.
    @inlinable @inline(__always) public static var normal: Self { .init() }
}
