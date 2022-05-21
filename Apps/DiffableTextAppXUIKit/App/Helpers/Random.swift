//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Random
//*============================================================================*

extension Character {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilitis
    //=------------------------------------------------------------------------=
    
    static func random(in bounds: ClosedRange<Unicode.Scalar>) -> Character? {
        let bounds = ClosedRange(uncheckedBounds:
        (bounds.lowerBound.value, bounds.upperBound.value))
        return UnicodeScalar(UInt32.random(in: bounds)).map(Character.init)
    }
}
