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
    
    @usableFromInline let bounds:    _Bounds<Input>
    @usableFromInline let precision: _Precision<Input>
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(bounds: _Bounds<Input>, precision: _Precision<Input>) {
        self.bounds = bounds; self.precision = precision
    }
    
    @inlinable static func standard() -> Self {
        Self(bounds: _Bounds(), precision: _Precision())
    }
    
    /// - Requires that formatter.maximumFractionDigits == default.
    @inlinable static func currency(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .currency)
        
        let fraction: ClosedRange<Int> =
        formatter.minimumFractionDigits ...
        formatter.maximumFractionDigits
        
        return Self(bounds: _Bounds(), precision: _Precision(fraction: fraction))
    }
}
