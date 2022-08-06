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
// MARK: * Label
//*============================================================================*

@usableFromInline struct Label {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let text: String
    @usableFromInline let direction: Direction
    @usableFromInline let virtual: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ text: String, direction: Direction) {
        self.text = text
        self.direction = direction
        self.virtual = false
    }
    
    @inlinable init(_ text: String, in body: String, virtual: Bool) {
        let match = body.range(of: text)!
        
        let lhs = (match.lowerBound == body.startIndex)
        let rhs = (match.upperBound == body  .endIndex)
        
        self.text = text
        self.direction = (lhs || !rhs) ? .forwards : .backwards
        self.virtual = virtual
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    /// Correctness is asserted by parsing all combinations.
    @inlinable static func currency(
    _ formatter: NumberFormatter, with components: Components) -> Self {
        assert(formatter.numberStyle == .currency)
        assert(formatter.maximumFractionDigits == 0)
        
        let text = formatter.currencySymbol!
        let body = formatter.string(from:0)!
        
        return Self(text, in: String(body), virtual: text.allSatisfy(components.virtual))
    }
    
    @inlinable static func measurement<T>(
    _ formatter: Measurement<T>.FormatStyle, unit: T, with components: Components) -> Self {
        let body = formatter.attributed.format(Measurement(value: 0, unit: unit))
        let text = String(body[body.runs.first{$0.measurement == .unit}!.range].characters)
        return Self(text, in: String(body.characters), virtual: text.allSatisfy(components.virtual))
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot) {
        if  virtual { return }
        
        if  let label = Search.range(of: text, in: snapshot, towards:  direction ){
            snapshot.transform(attributes: label, with: { $0 = Attribute.phantom })
        }
    }
}
