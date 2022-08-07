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
    @usableFromInline var virtual: Bool = false
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ text: String, search direction: Direction) {
        self.text = text; self.direction = direction
    }
    
    @inlinable init(_ text: String, context: String) {
        let match = context.range(of: text)!

        let lhs = (match.lowerBound == context.startIndex)
        let rhs = (match.upperBound == context  .endIndex)
        
        self.init(text, search: (lhs || !rhs) ? .forwards : .backwards)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    /// - Test by parsing each combination.
    @inlinable static func currency(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle  ==  .currency)
        assert(formatter.maximumFractionDigits == 0)
        
        let text = formatter.currencySymbol!
        let body = formatter.string(from:0)!
        
        return Self(text, context: String(body))
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
