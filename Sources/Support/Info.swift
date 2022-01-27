//
//  Info.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-05.
//

//*============================================================================*
// MARK: * Info
//*============================================================================*

/// An error message that contains a description in DEBUG mode.
///
/// - Uses conditional compilation.
///
public struct Info: CustomStringConvertible, Error {
    @usableFromInline static let description = "[DEBUG]"
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    #if DEBUG
    public let description: String
    #else
    public var description: String { Self.description }
    #endif
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public init(description: @autoclosure () -> String) {
        #if DEBUG
        self.description = description()
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public init(_ components: () -> [Component]) {
        self.init(description: components().map(\.content).joined(separator: " "))
    }
    
    @inlinable @inline(__always) public init(_ components: @autoclosure () -> [Component]) {
        self.init(components)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public static func print(_ description: @autoclosure () -> String) {
        #if DEBUG
        Swift.print(description())
        #endif
    }
    
    @inlinable @inline(__always) public static func print(_ components: () -> [Component]) {
        Self.print(components().description)
    }
    
    @inlinable @inline(__always) public static func print(_ components: @autoclosure () -> [Component]) {
        Self.print(components().description)
    }
    
    //*========================================================================*
    // MARK: * Component
    //*========================================================================*
    
    public struct Component: ExpressibleByStringLiteral {
        
        //=--------------------------------------------------------------------=
        // MARK: Properties
        //=--------------------------------------------------------------------=
        
        public let content: String
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(content: String) {
            self.content = content
        }
        
        @inlinable public init(stringLiteral value: StringLiteralType) {
            self.content = value
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers - Static
        //=--------------------------------------------------------------------=
        
        @inlinable public static func note(_ value: Any) -> Self {
            Self(content: String(describing: value))
        }
        
        @inlinable public static func mark(_ value: Any) -> Self {
            Self(content: "« \(String(describing: value)) »")
        }
    }
}
