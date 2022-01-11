//
//  Component.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

//*============================================================================*
// MARK: * Components
//*============================================================================*

@usableFromInline protocol Component: TextOutputStreamable { }

//=------------------------------------------------------------------------=
// MARK: Components - Implementation
//=------------------------------------------------------------------------=

extension Component where Self: RawRepresentable, RawValue == String {
    
    //=------------------------------------------------------------------------=
    // MARK: Write
    //=------------------------------------------------------------------------=
    
    @inlinable func write<Target: TextOutputStream>(to target: inout Target) {
        rawValue.write(to: &target)
    }
}
