//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

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
    
    @inlinable public var value:    Int { storage.x }
    @inlinable public var integer:  Int { storage.y }
    @inlinable public var fraction: Int { storage.z }
    
    //=------------------------------------------------------------------------=
    // MARK: Elements
    //=------------------------------------------------------------------------=

    @inlinable subscript(component: Component) -> Int {
        storage[component.rawValue]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable var components: [Component] { Self.components }
    
    //*========================================================================*
    // MARK: * Component
    //*========================================================================*
        
    @usableFromInline enum Component: Int, CaseIterable {
        case value    = 0
        case integer  = 1
        case fraction = 2
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let components = Component.allCases
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
    
    @inlinable func first(where predicate: ((SIMD, Int) -> Mask, Int)) -> Component? {
        let mask = predicate.0(storage, predicate.1)
        return components.first{ mask[$0.rawValue] }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Count: Brrr {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable public var descriptors: [(key: Any, value: Any)] {
        Count.components.map({($0, self.storage[$0.rawValue])})
    }
}