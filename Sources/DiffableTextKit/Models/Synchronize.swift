//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Synchronize [...]
//*============================================================================*

/// A message describing synchronization behavior.
@frozen public struct Synchronize: OptionSet {
    
    /// Requires input and output values to be equal.
    public static let invariant = Self(rawValue: 1 << 0)
    
    //=------------------------------------------------------------------------=
    
    public let rawValue: UInt8
    
    //=------------------------------------------------------------------------=
    
    @inlinable public init(rawValue: UInt8) { self.rawValue = rawValue }
}
