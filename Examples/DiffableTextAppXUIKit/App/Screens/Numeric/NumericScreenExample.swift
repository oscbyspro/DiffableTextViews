//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import DiffableTextViews

//*============================================================================*
// MARK: Declaration
//*============================================================================*

/// An examples view that observes frequent changes.
struct NumericScreenExample<Format: NumberTextFormat>: View where Format.FormatInput == NumericScreenContext.Value {
    typealias Context = NumericScreenContext
    typealias Integers = Interval<Int>
    typealias Value = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let base: _NumberTextStyle<Format>
    @ObservedObject var value: Source<Value>
    @ObservedObject var bounds: SourceOfBounds
    @ObservedObject var integer: Source<Integers>
    @ObservedObject var fraction: Source<Integers>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context, base: _NumberTextStyle<Format>) {
        self.base = base
        self.value = context.value
        self.bounds = context.bounds
        self.integer = context.integer
        self.fraction = context.fraction
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Example(value.binding, style: base.bounds(bounds.values).precision(
        integer: integer.content.closed, fraction: fraction.content.closed))
    }
}
