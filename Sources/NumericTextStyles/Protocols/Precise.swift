//
//  Precise.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

//*============================================================================*
// MARK: * Precise
//*============================================================================*

public protocol Precise {
    
    //=------------------------------------------------------------------------=
    // MARK: Lossless Limits
    //=------------------------------------------------------------------------=
    
    @inlinable static var maxLosslessIntegerDigits:     Int { get }
    @inlinable static var maxLosslessFractionDigits:    Int { get }
    @inlinable static var maxLosslessSignificantDigits: Int { get }
}

//=----------------------------------------------------------------------------=
// MARK: Precise - Details
//=----------------------------------------------------------------------------=

extension Precise {
    
    //=------------------------------------------------------------------------=
    // MARK: Values
    //=------------------------------------------------------------------------=
    
    @inlinable static var minLosslessIntegerDigits:     Int { 1 }
    @inlinable static var minLosslessFractionDigits:    Int { 0 }
    @inlinable static var minLosslessSignificantDigits: Int { 1 }
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable static var losslessIntegerLimits: ClosedRange<Int> {
        minLosslessIntegerDigits ... maxLosslessIntegerDigits
    }
    
    @inlinable static var losslessFractionLimits: ClosedRange<Int> {
        minLosslessFractionDigits ... maxLosslessFractionDigits
    }
    
    @inlinable static var losslessSignificantLimits: ClosedRange<Int> {
        minLosslessSignificantDigits ... maxLosslessSignificantDigits
    }
}

//*============================================================================*
// MARK: * Precise x Floating Point
//*============================================================================*

public protocol PreciseFloatingPoint: Precise { }

//=----------------------------------------------------------------------------=
// MARK: Precise x Floating Point - Implementation
//=----------------------------------------------------------------------------=

public extension PreciseFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Lossless Limits
    //=------------------------------------------------------------------------=

    @inlinable static var maxLosslessIntegerDigits: Int {
        maxLosslessSignificantDigits
    }
    
    @inlinable static var maxLosslessFractionDigits: Int {
        maxLosslessSignificantDigits
    }
}

//*============================================================================*
// MARK: * Precise x Floating Point
//*============================================================================*

public protocol PreciseInteger: Precise { }

//=----------------------------------------------------------------------------=
// MARK: Precise x Integer - Implementation
//=----------------------------------------------------------------------------=

public extension PreciseInteger {
    
    //=------------------------------------------------------------------------
    // MARK: Lossless Limits
    //=------------------------------------------------------------------------=
    
    @inlinable static var maxLosslessIntegerDigits: Int {
        maxLosslessSignificantDigits
    }
    
    @inlinable static var maxLosslessFractionDigits: Int {
        Int.zero
    }
}
