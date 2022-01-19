//
//  Decimals.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import Foundation

//*============================================================================*
// MARK: * Decimal
//*============================================================================*

extension Decimal: FloatingPointValue, SignedValue {

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(38)
    public static let bounds: ClosedRange<Self> = bounds(limit: Self(string: String(repeating: "9", count: 38))!)
}
