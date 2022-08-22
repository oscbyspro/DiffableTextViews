//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Changes [...]
//*============================================================================*

/// A model used to capture comparison results.
@frozen @usableFromInline struct Changes: OptionSet {
    
    public static let style = Self(rawValue: 1 << 0)
    public static let value = Self(rawValue: 1 << 1)
    public static let focus = Self(rawValue: 1 << 2)
    
    //=------------------------------------------------------------------------=
    
    public var rawValue: UInt8
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(rawValue: UInt8) { self.rawValue = rawValue }
}
