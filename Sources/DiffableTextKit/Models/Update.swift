//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Update [...]
//*============================================================================*

/// A message describing which properties should be updated.
@frozen public struct Update: OptionSet {
        
    public static let text      = Self(rawValue: 1 << 0)
    public static let selection = Self(rawValue: 1 << 1)
    public static let value     = Self(rawValue: 1 << 2)
    
    //=------------------------------------------------------------------------=
    
    public let rawValue: UInt8
    
    //=------------------------------------------------------------------------=
    
    @inlinable public init(rawValue: UInt8) { self.rawValue = rawValue }
}
