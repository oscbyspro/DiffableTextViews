//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: Declaration
//*============================================================================*

public struct Update: OptionSet {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    public static let value     = Self(rawValue: 1 << 0)
    public static let text      = Self(rawValue: 1 << 1)
    public static let selection = Self(rawValue: 1 << 2)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let rawValue: UInt8
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public init(rawValue: UInt8 = 0) {
        self.rawValue = rawValue
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func value(_ condition: Bool) -> Self {
        !condition ? .init() : .value
    }
    
    @inlinable @inline(__always)
    public static func text(_ condition: Bool) -> Self {
        !condition ? .init() : .text
    }
    
    @inlinable @inline(__always)
    public static func selection(_ condition: Bool) -> Self {
        !condition ? .init() : .selection
    }
}
