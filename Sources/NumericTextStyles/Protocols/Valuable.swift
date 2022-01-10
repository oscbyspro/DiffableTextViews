//
//  Valuable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

//*============================================================================*
// MARK: * Valuable
//*============================================================================*

public protocol Valuable: Formattable, Boundable, Precise {
    
    //=------------------------------------------------------------------------=
    // MARK: Value, Options
    //=------------------------------------------------------------------------=
    
    @inlinable static var zero: Self { get }
    @inlinable static var options: Options { get }
}

//*============================================================================*
// MARK: * Valuable x Float
//*============================================================================*

@usableFromInline protocol ValuableFloat: Valuable, FormattableFloatingPoint, BoundableFloatingPoint, PreciseFloatingPoint { }

//=----------------------------------------------------------------------------=
// MARK: Valuable x Float - Implementation
//=----------------------------------------------------------------------------=

extension ValuableFloat {
    
    //=------------------------------------------------------------------------=
    // MARK: Options
    //=------------------------------------------------------------------------=
    
    @inlinable public static var options: Options { .floatingPoint }
}

//*============================================================================*
// MARK: * Valuable x Int
//*============================================================================*

@usableFromInline protocol ValuableInt: Valuable, FormattableInteger, BoundableInteger, PreciseInteger { }

//=----------------------------------------------------------------------------=
// MARK: Valuable x Int - Implementation
//=----------------------------------------------------------------------------=

extension ValuableInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Options
    //=------------------------------------------------------------------------=
    
    @inlinable public static var options: Options { .integer }
}

//*============================================================================*
// MARK: * Valuable x UInt
//*============================================================================*

@usableFromInline protocol ValuableUInt: Valuable, FormattableInteger, BoundableInteger, PreciseInteger { }

//=----------------------------------------------------------------------------=
// MARK: Valuable x UInt - Implementation
//=----------------------------------------------------------------------------=

extension ValuableUInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Options
    //=------------------------------------------------------------------------=
    
    @inlinable public static var options: Options { .unsignedInteger }
}
