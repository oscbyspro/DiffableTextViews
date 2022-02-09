//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UInt
//*============================================================================*

extension UInt: LimitedUInt { @usableFromInline typealias Limit = Int }

//*============================================================================*
// MARK: * UInt8
//*============================================================================*

extension UInt8: IntegerValue, UnsignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = precision(3)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * UInt16
//*============================================================================*

extension UInt16: IntegerValue, UnsignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = precision(5)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * UInt32
//*============================================================================*

extension UInt32: IntegerValue, UnsignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = precision(10)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * UInt64
//*============================================================================*

extension UInt64: LimitedUInt { @usableFromInline typealias Limit = Int64 }

//*============================================================================*
// MARK: * LimitedUInt
//*============================================================================*

/// See notes on Swift issues for why this protocol is needed.
///
/// - No crash. Such wow. Very impress.
///
@usableFromInline protocol LimitedUInt: BinaryInteger, IntegerValue, UnsignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Limit
    //=------------------------------------------------------------------------=
    
    associatedtype Limit: BinaryInteger, IntegerValue, SignedValue
}

//=----------------------------------------------------------------------------=
// MARK: LimitedUInt - Details
//=----------------------------------------------------------------------------=

extension LimitedUInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    @inlinable public static var precision: Count {
        Limit.precision
    }
    
    @inlinable public static var bounds: ClosedRange<Self> {
        0...Self(Limit.bounds.upperBound)
    }
}
