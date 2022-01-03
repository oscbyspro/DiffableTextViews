//
//  Boundable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

//*============================================================================*
// MARK: * Boundable
//*============================================================================*

public protocol Boundable: Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: Values
    //=------------------------------------------------------------------------=
    
    /// The zero value.
    @inlinable static var zero: Self { get }
    
    /// - Less than or equal to zero.
    @inlinable static var minLosslessValue: Self { get }
    
    /// - Greater than or equal to zero.
    @inlinable static var maxLosslessValue: Self { get }
}

//*============================================================================*
// MARK: * Boundable x Floating Point
//*============================================================================*

@usableFromInline protocol BoundableFloatingPoint: Boundable, BinaryFloatingPoint { }
extension BoundableFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Values
    //=------------------------------------------------------------------------=
    
    @inlinable public static var minLosslessValue: Self {
        -maxLosslessValue
    }
}

//*============================================================================*
// MARK: * Boundable x Integer
//*============================================================================*

@usableFromInline protocol BoundableInteger: Boundable, FixedWidthInteger { }
extension BoundableInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Values
    //=------------------------------------------------------------------------=
    
    @inlinable public static var minLosslessValue: Self { min }
    @inlinable public static var maxLosslessValue: Self { max }
}
