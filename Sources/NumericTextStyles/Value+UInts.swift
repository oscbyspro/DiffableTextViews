//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * UInt
//*============================================================================*

extension UInt: Values.Unsigned, Values.Integer {
    public typealias FormatStyle = IntegerFormatStyle<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = Int.precision
    public static let bounds: ClosedRange<Self> = 0...Self(Int.bounds.upperBound)
}

//*============================================================================*
// MARK: * UInt8
//*============================================================================*

extension UInt8: Values.Unsigned, Values.Integer {
    public typealias FormatStyle = IntegerFormatStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = precision(3)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * UInt16
//*============================================================================*

extension UInt16: Values.Unsigned, Values.Integer {
    public typealias FormatStyle = IntegerFormatStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = precision(5)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * UInt32
//*============================================================================*

extension UInt32: Values.Unsigned, Values.Integer {
    public typealias FormatStyle = IntegerFormatStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = precision(10)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * UInt64
//*============================================================================*

extension UInt64: Values.Unsigned, Values.Integer {
    public typealias FormatStyle = IntegerFormatStyle<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = Int64.precision
    public static let bounds: ClosedRange<Self> = 0...Self(Int64.bounds.upperBound)
}
