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

@usableFromInline struct Preferences<Value: _Input> {
    
    @usableFromInline typealias Bounds    = _Bounds   <Value>
    @usableFromInline typealias Precision = _Precision<Value>
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline let bounds:    Bounds
    @usableFromInline let precision: Precision
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(bounds: Bounds, precision: Precision) {
        self.bounds = bounds; self.precision = precision
    }
    
    @inlinable static func standard() -> Self {
        Self(bounds: Bounds(), precision: Precision())
    }
    
    /// - Requires that formatter.maximumFractionDigits == default.
    @inlinable static func currency(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .currency)
        
        let precision = Precision(fraction:
        formatter.minimumFractionDigits ...
        formatter.maximumFractionDigits)
        
        return Self(bounds: _Bounds(), precision: precision)
    }
}
