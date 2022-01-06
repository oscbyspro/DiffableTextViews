//
//  Description.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-05.
//

import QuickText

//*============================================================================*
// MARK: * Description
//*============================================================================*

public struct Description: Text {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    public let body: DEBUG
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(@MakeUnknown _ content: () -> Unknown) {
        self.body = DEBUG({ content() })
    }
    
    //
    // MARK: Initializers - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ components: @autoclosure () -> [Component]) {
        self.init({ List(components()).joined(with: " ") })
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
            Self({ Note(String(describing: value)) })
        }
        
        @inlinable public static func mark(_ value: Any) -> Self {
            Self {
                Joined(with: " ") {
                    Note("«")
                    Note(String(describing: value)).filter({ !$0.isEmpty })
                    Note("»")
                }
            }
        }
    }
}
