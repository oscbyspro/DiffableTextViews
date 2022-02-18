//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Float16
//*============================================================================*

extension Float16: Values.Signed, Values.FloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(3)
    public static let bounds: ClosedRange<Self> = bounds(limit: 999)
}

//*============================================================================*
// MARK: * Float32
//*============================================================================*

extension Float32: Values.Signed, Values.FloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(7)
    public static let bounds: ClosedRange<Self> = bounds(limit: 9_999_999)
}

//*============================================================================*
// MARK: * Float64
//*============================================================================*

extension Float64: Values.Signed, Values.FloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(15)
    public static let bounds: ClosedRange<Self> = bounds(limit: 999_999_999_999_999)
}
