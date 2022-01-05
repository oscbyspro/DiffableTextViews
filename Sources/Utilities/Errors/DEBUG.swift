//
//  DEBUG.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-05.
//

import QuickText

//*============================================================================*
// MARK: * DEBUG
//*============================================================================*

public struct DEBUG: Text {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    public let body: Redacted
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(@MakeUnknown _ content: () -> Unknown) {
        self.body = Redacted {
            content().joined(with: " ")
        }
    }
    
    //
    // MARK: Initializers - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ components: @autoclosure () -> [Component]) {
        self.init({ List(components()) })
    }

    //*========================================================================*
    // MARK: * Component
    //*========================================================================*
    
    public struct Component: Text, ExpressibleByStringLiteral {
        
        //=--------------------------------------------------------------------=
        // MARK: Properties
        //=--------------------------------------------------------------------=
        
        public let body: Unknown
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(@MakeUnknown _ content: () -> Unknown) {
            self.body = content()
        }
        
        @inlinable public init(stringLiteral value: StringLiteralType) {
            self = .note(value)
        }
        
        //
        // MARK: Initializers - Static
        //=------------------------------------------------------------------------=
        
        @inlinable public static func note(_ value: Any) -> Self {
            Self { Note(value) }
        }
        
        @inlinable public static func mark(_ value: Any) -> Self {
            Self { Note(value).quote(with: .angle) }
        }
    }
}
