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
// MARK: * Int x Protocol
//*============================================================================*

@usableFromInline protocol _Int: BinaryInteger, Values.Signed, Values.Integer,
Values.Numberable, Values.Currencyable where FormatStyle == IntegerFormatStyle<Self> { }

//*============================================================================*
// MARK: * Int
//*============================================================================*

extension Int: _Int {
    public typealias FormatStyle = IntegerFormatStyle<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(String(max).count)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * Int8
//*============================================================================*

extension Int8: _Int {
    public typealias FormatStyle = IntegerFormatStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(3)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * Int16
//*============================================================================*

extension Int16: _Int {
    public typealias FormatStyle = IntegerFormatStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(5)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * Int32
//*============================================================================*

extension Int32: _Int {
    public typealias FormatStyle = IntegerFormatStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(10)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * Int64
//*============================================================================*

extension Int64: _Int {
    public typealias FormatStyle = IntegerFormatStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(19)
    public static let bounds: ClosedRange<Self> = bounds()
}
