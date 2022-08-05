//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Formatter
//*============================================================================*

@usableFromInline struct Formatter<Format: _Format> where Format.FormatInput: _Input {
    
    @usableFromInline typealias Value = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var base: Format
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(initial: Format) {
        self.base = initial.rounded(rule: .towardZero, increment: nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ precision: _NFSC.Precision) -> Self {
        var result = self; result.base = result.base.precision(precision); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_ value: Value) -> String {
        base.format(value)
    }
    
    @inlinable func format(_ value: Value, _ number: Number, with components: Components) -> String {
        //=--------------------------------------=
        // Characters
        //=--------------------------------------=
        let sign       = Format._SignDS(number.sign ==  .negative ? .always : .automatic)
        let separator  = number.separator != nil ? _NFSC_SeparatorDS.always : .automatic
        var characters = base.sign(strategy: sign).decimalSeparator(strategy:  separator).format(value)
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        if number.sign == .negative, value == .zero, let index =
        characters.firstIndex(of: components.signs[.positive]) {
            //=----------------------------------=
            // Make Positive Zero Negative
            //=----------------------------------=
            characters.replaceSubrange(index...index, with: String(components.signs[.negative]))
        }
        //=--------------------------------------=
        // Characters
        //=--------------------------------------=
        return characters
    }
}
