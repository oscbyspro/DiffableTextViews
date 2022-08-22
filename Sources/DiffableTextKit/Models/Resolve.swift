//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*========================================================================*
// MARK: * Resolve [...]
//*========================================================================*

/// A message describing selection behavior.
@usableFromInline struct Resolve: OptionSet {
    
    /// Resolve max selection.
    public static let max = Self(rawValue: 1 << 0)
    
    /// Resolve selection by using caret momentums.
    public static let momentums = Self(rawValue: 1 << 1)
    
    //=--------------------------------------------------------------------=
    
    @usableFromInline var rawValue: UInt8
    
    //=--------------------------------------------------------------------=
    
    @usableFromInline init(rawValue: UInt8) { self.rawValue = rawValue }
}
