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
// MARK: * Preferences [...]
//*============================================================================*

@usableFromInline struct Preferences<Input> where Input: _Input {
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline let bounds:    Bounds<Input>
    @usableFromInline let precision: Precision<Input>
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(bounds: Bounds<Input>, precision: Precision<Input>) {
        self.bounds = bounds; self.precision = precision
    }
    
    @inlinable static func standard() -> Self {
        Self(bounds: Bounds(), precision: Precision())
    }
    
    /// - Requires that formatter.maximumFractionDigits == default.
    @inlinable static func currency(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .currency)
        
        let precision = Precision<Input>(fraction:
        formatter.minimumFractionDigits ...
        formatter.maximumFractionDigits)
        
        return Self(bounds: Bounds(), precision: precision)
    }
}
