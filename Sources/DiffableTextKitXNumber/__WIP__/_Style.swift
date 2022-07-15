//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Style
//*============================================================================*

public protocol _Style: DiffableTextStyle where Cache: _Cache, Value: NumberTextKind {
    
    //=------------------------------------------------------------------------=
    // MARK: Format
    //=------------------------------------------------------------------------=
        
    typealias Format = Cache.Format
    
    typealias Input = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ limits: ClosedRange<Input>) -> Self
    
    @inlinable func bounds(_ limits: PartialRangeFrom<Input>) -> Self
    
    @inlinable func bounds(_ limits: PartialRangeThrough<Input>) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(integer: Int) -> Self
    
    @inlinable func precision(fraction: Int) -> Self
    
    @inlinable func precision(integer: Int, fraction: Int) -> Self
    
    @inlinable func precision<I>(integer: I, fraction: Int) -> Self
    where I: RangeExpression, I.Bound == Int
    
    @inlinable func precision<F>(integer: Int, fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int
    
    @inlinable func precision<I>(integer: I) -> Self
    where I: RangeExpression, I.Bound == Int
    
    @inlinable func precision<F>(fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int
    
    @inlinable func precision<I, F>(integer: I, fraction: F) -> Self
    where I: RangeExpression, I.Bound == Int, F: RangeExpression, F.Bound == Int
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Input: Integer
//=----------------------------------------------------------------------------=

public extension _Style where Input: NumberTextValueXInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ length: Int) -> Self {
        self.precision(integer: length...length)
    }

    @inlinable func precision<I>(_ limits: I) -> Self
    where I: RangeExpression, I.Bound == Int {
        self.precision(integer: limits)
    }
}
