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

/// An error message that contains a description in DEBUG mode.
///
/// It uses conditional compilation such that it has no performance cost in RELEASE mode.
///
public struct Info: CustomStringConvertible, Error {
    @usableFromInline static let description = "[DEBUG]"
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    #if DEBUG
    public let description: String
    #else
    public var description: String { Self.description }
    #endif
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public init(_ description: @autoclosure () -> String) {
        #if DEBUG
        self.description = description()
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Print
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func print(_ description: @autoclosure () -> String) {
        #if DEBUG
        Swift.print(description())
        #endif
    }
    
    //*========================================================================*
    // MARK: Component
    //*========================================================================*
    
    public struct Component: ExpressibleByStringLiteral {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let content: String
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init( _ content: String) {
            self.content = content
        }
        
        @inlinable public init(stringLiteral content: StringLiteralType) {
            self.content = content
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public static func note(_ value: Any) -> Self {
            Self(String(describing: value))
        }
        
        @inlinable public static func mark(_ value: Any) -> Self {
            Self("« \(value) »")
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Initializers
//=----------------------------------------------------------------------------=

public extension Info {
    
    //=------------------------------------------------------------------------=
    // MARK: Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(_ components: @autoclosure () -> [Component]) {
        self.init(components().map(\.content).joined(separator: " "))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Print
//=----------------------------------------------------------------------------=

public extension Info {
    
    //=------------------------------------------------------------------------=
    // MARK: Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    static func print(_ components: @autoclosure () -> [Component]) {
        self.print(String(describing: Info(components())))
    }
    
    @inlinable @inline(__always)
    static func print(cancellation components: @autoclosure () -> [Component]) {
        self.print(["User input cancelled:"] + components())
    }
    
    @inlinable @inline(__always)
    static func print(autocorrection components: @autoclosure () -> [Component]) {
        self.print(["User input autocorrected:"] + components())
    }
}
