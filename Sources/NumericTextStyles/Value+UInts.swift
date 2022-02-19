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

extension UInt: Value.Unsigned, Value.Integer, Value.Number, Value.Currency {
    typealias Limit = Int // no crash. such wow. very impress.
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = Limit.precision
    public static let bounds: ClosedRange<Self> = 0...Self(Limit.bounds.upperBound)
}

//*============================================================================*
// MARK: * UInt8
//*============================================================================*

extension UInt8: Value.Unsigned, Value.Integer, Value.Number, Value.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = precision(3)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * UInt16
//*============================================================================*

extension UInt16: Value.Unsigned, Value.Integer, Value.Number, Value.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = precision(5)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * UInt32
//*============================================================================*

extension UInt32: Value.Unsigned, Value.Integer, Value.Number, Value.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = precision(10)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * UInt64
//*============================================================================*

extension UInt64: Value.Unsigned, Value.Integer, Value.Number, Value.Currency {
    typealias Limit = Int64 // no crash. such wow. very impress.
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = Limit.precision
    public static let bounds: ClosedRange<Self> = 0...Self(Limit.bounds.upperBound)
}
