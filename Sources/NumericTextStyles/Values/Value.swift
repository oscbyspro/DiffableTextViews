//
//  Value.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

//*============================================================================*
// MARK: * Value
//*============================================================================*

public protocol Value: Boundable, Precise {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @inlinable static var isInteger:  Bool { get }
    @inlinable static var isUnsigned: Bool { get }
}

//*============================================================================*
// MARK: * Value x Floating Point
//*============================================================================*

@usableFromInline protocol FloatingPointValue: Value, BoundableFloatingPoint, PreciseFloatingPoint { }

//=----------------------------------------------------------------------------=
// MARK: Value x Floating Point - Implementation
//=----------------------------------------------------------------------------=

extension FloatingPointValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isInteger:  Bool { false }
    @inlinable public static var isUnsigned: Bool { false }
}

//*============================================================================*
// MARK: * Value x Integer
//*============================================================================*

@usableFromInline protocol IntegerValue: Value, BoundableInteger, PreciseInteger { }

//=----------------------------------------------------------------------------=
// MARK: Value x Integer - Implementation
//=----------------------------------------------------------------------------=

extension IntegerValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isInteger:  Bool { true  }
    @inlinable public static var isUnsigned: Bool { false }
}

//*============================================================================*
// MARK: * Value x Unsigned Integer
//*============================================================================*

@usableFromInline protocol UnsignedIntegerValue: Value, BoundableInteger, PreciseInteger { }

//=----------------------------------------------------------------------------=
// MARK: Value x Unsigned Integer - Implementation
//=----------------------------------------------------------------------------=

extension UnsignedIntegerValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isInteger:  Bool { true }
    @inlinable public static var isUnsigned: Bool { true }
}
