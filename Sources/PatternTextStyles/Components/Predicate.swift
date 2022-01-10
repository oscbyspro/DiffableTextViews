//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-10.
//

//*========================================================================*
// MARK: * Predicate
//*========================================================================*

public struct Predicate<Value: Collection> where Value.Element == Character {

    //=--------------------------------------------------------------------=
    // MARK: Properties
    //=--------------------------------------------------------------------=
    
    @usableFromInline let validate: (Value) -> Bool
    
    //=--------------------------------------------------------------------=
    // MARK: Initializers
    //=--------------------------------------------------------------------=
    
    @inlinable init(validate: @escaping (Value) -> Bool) {
        self.validate = validate
    }
    
    //
    // MARK: Initializers - Static
    //=--------------------------------------------------------------------=
    
    @inlinable public static func value(_ predicate: @escaping (Value) -> Bool) -> Self {
        .init(validate: predicate)
    }
    
    @inlinable public static func character(_ predicate: @escaping (Character) -> Bool) -> Self {
        .init(validate: { characters in characters.allSatisfy(predicate) })
    }
}
