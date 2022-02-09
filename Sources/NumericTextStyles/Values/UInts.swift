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

extension UInt: IntegerValue, UnsignedValue {
    typealias Limit = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = Limit.precision
    public static let bounds: ClosedRange<Self> = 0...Limit.bounds.upperBound
}

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

extension UInt64: IntegerValue, UnsignedValue {
    typealias Limit = UInt64
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = Limit.precision
    public static let bounds: ClosedRange<Self> = 0...Limit.bounds.upperBound
}
