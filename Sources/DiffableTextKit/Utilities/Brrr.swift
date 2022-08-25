//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Brrr [...]
//*============================================================================*

/// A model that prints messages in DEBUG mode.
///
/// It uses conditional compilation such that it has no size or cost in RELEASE mode.
///
public struct Brrr: Equatable {
        
    public static let dismiss          = Self("dismiss")
    public static let cancellation     = Self("cancellation")
    public static let autocorrection   = Self("autocorrection")
    public static let unsynchronizable = Self("unsynchronizable")

    //=------------------------------------------------------------------------=
    
    #if DEBUG
    @usableFromInline let context: String
    #endif
    
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public init(_ context: @autoclosure () -> String) {
        #if DEBUG
        self.context = context()
        #endif
    }
    
    @inlinable @inline(__always) public static func << (brrr: Self, message: @autoclosure () -> Any) {
        #if DEBUG
        Swift.print("[DiffableTextViews] \(brrr.context): \(message())")
        #endif
    }
}
