//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Info
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
    public init(description: @autoclosure () -> String) {
        #if DEBUG
        self.description = description()
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public init(_ components: @autoclosure () -> [Component]) {
        self.init(description: components().map(\.content).joined(separator: " "))
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
    
    //=------------------------------------------------------------------------=
    // MARK: Print - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func print(_ components: @autoclosure () -> [Component]) {
        self.print(String(describing: Info(components())))
    }
    
    //*========================================================================*
    // MARK: * Component
    //*========================================================================*
    
    public struct Component: ExpressibleByStringLiteral {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let content: String
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(content: String) {
            self.content = content
        }
        
        @inlinable public init(stringLiteral content: StringLiteralType) {
            self.content = content
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers - Static
        //=--------------------------------------------------------------------=
        
        @inlinable public static func note(_ value: Any) -> Self {
            Self(content: String(describing: value))
        }
        
        @inlinable public static func mark(_ value: Any) -> Self {
            Self(content: "« \(value) »")
        }
    }
}

//*============================================================================*
// MARK: * Info x Component
//*============================================================================*

extension Info.Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=

    @inlinable public static var cancellation: Self {
        "User input cancelled:"
    }
    
    @inlinable public static var autocorrection: Self {
        "User input autocorrected:"
    }
}
