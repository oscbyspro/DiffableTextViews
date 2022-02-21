//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Int
//*============================================================================*

extension Int: Values.Signed, Values.Integer, Values.Number, Values.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(String(max).count)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * Int8
//*============================================================================*

extension Int8: Values.Signed, Values.Integer, Values.Number, Values.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(3)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * Int16
//*============================================================================*

extension Int16: Values.Signed, Values.Integer, Values.Number, Values.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(5)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * Int32
//*============================================================================*

extension Int32: Values.Signed, Values.Integer, Values.Number, Values.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(10)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * Int64
//*============================================================================*

extension Int64: Values.Signed, Values.Integer, Values.Number, Values.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(19)
    public static let bounds: ClosedRange<Self> = bounds()
}
