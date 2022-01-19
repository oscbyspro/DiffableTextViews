//
//  Count.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-24.
//

/// A count of a number's various components.
///
/// - Lanes: | value | integer | fraction |
///
public struct Count {
    @usableFromInline typealias Storage = SIMD3<Int>
    @usableFromInline typealias Transform = (Storage, Storage) -> Storage

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(storage: Storage) {
        self.storage = storage
    }
    
    @inlinable init(value: Int, integer: Int, fraction: Int) {
        self.storage = Storage(value, integer, fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var value:    Int { storage.x }
    @inlinable var integer:  Int { storage.y }
    @inlinable var fraction: Int { storage.z }

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func map(_ transform: Transform, _ other: Self) -> Self {
        Self(storage: transform(storage, other.storage))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func upshifted(by amount: Int) -> Self {
        map(&+, Self(value: 0, integer: amount, fraction: -amount))
    }
    
    @inlinable func downshifted(by amount: Int) -> Self {
        map(&-, Self(value: 0, integer: -amount, fraction: amount))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Count - DEBUG
//=----------------------------------------------------------------------------=

extension Count {
        
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(component: Component) -> Int {
        switch component {
        case .value:    return value
        case .integer:  return integer
        case .fraction: return fraction
        }
    }

    //*========================================================================*
    // MARK: * Component
    //*========================================================================*
    
    @usableFromInline enum Component { case value, integer, fraction }
}
