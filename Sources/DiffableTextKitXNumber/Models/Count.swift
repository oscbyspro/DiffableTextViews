//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Count [...]
//*============================================================================*

/// A count of a number's components.
///
/// - It SHOULD NOT include leading integer zeros.
///
@usableFromInline struct Count: CustomStringConvertible, Equatable {
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline let digits:   Int
    @usableFromInline let integer:  Int
    @usableFromInline let fraction: Int
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(digits: Int, integer: Int, fraction: Int) {
        self.digits = digits; self.integer = integer; self.fraction = fraction
    }
    
    @inlinable init(_ number: Number) {
        self.integer  = number.integer.count - number.integer.count(prefix:{$0 == .zero})
        self.fraction = number.fraction.count; self.digits = self.integer + self.fraction
    }
    
    public var description: String {
        String(describing: (digits, integer, fraction))
    }
}
