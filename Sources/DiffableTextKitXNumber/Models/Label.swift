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
    @usableFromInline var virtual: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ text: String, direction: Direction, virtual: Bool = false) {
        self.text = text
        self.direction = direction
        self.virtual = virtual
    }
    
    @inlinable init(_ text: String, context: String) {
        let match = context.range(of: text)!

        let lhs = (match.lowerBound == context.startIndex)
        let rhs = (match.upperBound == context  .endIndex)
        
        self.init(text, direction: (lhs || !rhs) ? .forwards : .backwards)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    /// - Tests should parse all combinations.
    @inlinable static func currency(
    _ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .currency)
        assert(formatter.maximumFractionDigits == 0)
        
        let text = formatter.currencySymbol!
        let body = formatter.string(from:0)!
        
        return Self(text, context: String(body))
    }
    
    /// - Tests should parse all combinations.
    @inlinable static func measurement<Unit>(
    _ formatter: Measurement<Unit>.FormatStyle, unit: Unit) -> Self {
        let measurement = Measurement(value: 0, unit: unit)
        let body = formatter.attributed.format(measurement)
        let unit = body.runs.first{$0.measurement == .unit}!
        let text = String(body[unit.range].characters)
                
        return Self(text, context:  String(body.characters))
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
