//
//  Component.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

//*============================================================================*
// MARK: * Components
//*============================================================================*

@usableFromInline protocol Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    @inlinable func characters() -> String
    
    //=------------------------------------------------------------------------=
    // MARK: Write
    //=------------------------------------------------------------------------=
    
    @inlinable func write<Stream: TextOutputStream>(to stream: inout Stream)
}

//=------------------------------------------------------------------------=
// MARK: Components - RawValue == String
//=------------------------------------------------------------------------=

extension Component where Self: RawRepresentable, RawValue == String {
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    @inlinable func characters() -> String {
        rawValue
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Write
    //=------------------------------------------------------------------------=
    
    @inlinable func write<Stream: TextOutputStream>(to stream: inout Stream) {
        rawValue.write(to: &stream)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Components - RawValue == Character
//=----------------------------------------------------------------------------=

extension Component where Self: RawRepresentable, RawValue == Character {
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    @inlinable func characters() -> String {
        String(rawValue)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Write
    //=------------------------------------------------------------------------=
    
    @inlinable func write<Stream: TextOutputStream>(to stream: inout Stream) {
        rawValue.write(to: &stream)
    }
}
