//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Count
//*============================================================================*

/// A count of a number's components.
///
/// - Value is defined as: integer + fraction - integer prefix zeros.
///
public struct Count: Equatable {
    @usableFromInline typealias SIMD = SIMD3<Int>
    @usableFromInline typealias Mask = SIMDMask<SIMD>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: SIMD

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(_ storage: SIMD) {
        self.storage = storage
    }
    
    @inlinable init(value: Int, integer: Int, fraction: Int) {
        self.storage = SIMD3<Int>(value, integer, fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var value:    Int { storage.x }
    @inlinable var integer:  Int { storage.y }
    @inlinable var fraction: Int { storage.z }
    
    //=------------------------------------------------------------------------=
    // MARK: Elements
    //=------------------------------------------------------------------------=

    @inlinable subscript(component: Component) -> Int {
        storage[component.rawValue]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable var indices: [Component] { Component.all }
    
    //*========================================================================*
    // MARK: * Index
    //*========================================================================*
    
    @usableFromInline enum Component: Int {
        
        //=--------------------------------------------------------------------=
        // MARK: Instances
        //=--------------------------------------------------------------------=
        
        case value    = 0
        case integer  = 1
        case fraction = 2
        
        //=--------------------------------------------------------------------=
        // MARK: Constants
        //=--------------------------------------------------------------------=
        
        @usableFromInline static let all: [Self] = [.value, .integer, .fraction]
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension Count {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func map(_ transformation: ((SIMD, SIMD) -> SIMD, Self)) -> Self {
        Self(transformation.0(storage, transformation.1.storage))
    }

    //=------------------------------------------------------------------------=
    // MARK: Search
    //=------------------------------------------------------------------------=
    
    @inlinable func first<T>(where predicate: ((SIMD, T) -> Mask, T)) -> Component? {
        let result = predicate.0(storage, predicate.1)
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        for component in indices where result[component.rawValue] {
            return component
        }
        //=--------------------------------------=
        // MARK: Failure == None
        //=--------------------------------------=
        return nil
    }
}
