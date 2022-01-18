//
//  Info.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-05.
//

//*============================================================================*
// MARK: * Info
//*============================================================================*

/// An error message that is only constructed in DEBUG mode.
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
    
    @inlinable public init(content: () -> String) {
        #if DEBUG
        self.description = content()
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ components: @autoclosure () -> [Component]) {
        self.init(content: { components().map(\.content).joined(separator: " ") })
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

