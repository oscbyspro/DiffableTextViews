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
    // MARK: Options
    //=------------------------------------------------------------------------=
    
    @inlinable static var options: Options { get }
}

//=----------------------------------------------------------------------------=
// MARK: Value - Accessors
//=----------------------------------------------------------------------------=

extension Value {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable static var isInteger: Bool {
        options.contains(.integer)
    }
    
    @inlinable static var isUnsigned: Bool {
        options.contains(.unsigned)
    }
}

//*============================================================================*
// MARK: * Value x Floating Point
//*============================================================================*

@usableFromInline protocol FloatingPoint: Value, BoundableFloatingPoint, PreciseFloatingPoint { }

//=----------------------------------------------------------------------------=
// MARK: Value x Floating Point - Implementation
//=----------------------------------------------------------------------------=

extension FloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Options
    //=------------------------------------------------------------------------=
    
    @inlinable public static var options: Options { .floatingPoint }
}

//*============================================================================*
// MARK: * Value x Integer
//*============================================================================*

@usableFromInline protocol Integer: Value, BoundableInteger, PreciseInteger { }

//=----------------------------------------------------------------------------=
// MARK: Value x Integer - Implementation
//=----------------------------------------------------------------------------=

extension Integer {
    
    //=------------------------------------------------------------------------=
    // MARK: Options
    //=------------------------------------------------------------------------=
    
    @inlinable public static var options: Options { .integer }
}

//*============================================================================*
// MARK: * Value x Unsigned Integer
//*============================================================================*

@usableFromInline protocol UnsignedInteger: Value, BoundableInteger, PreciseInteger { }

//=----------------------------------------------------------------------------=
// MARK: Value x Unsigned Integer - Implementation
//=----------------------------------------------------------------------------=

extension UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Options
    //=------------------------------------------------------------------------=
    
    @inlinable public static var options: Options { .unsignedInteger }
}
