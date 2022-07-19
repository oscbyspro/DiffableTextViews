//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Adapter
//*============================================================================*

@usableFromInline struct _Adapter<Format: _Format> {
    @usableFromInline typealias Parser = Format.Strategy
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var format: Format
    @usableFromInline private(set) var parser: Parser
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// - Requires that the format has only been initialized.
    @inlinable init(unchecked: Format) {
        self.format = unchecked.rounded(rule: .towardZero, increment: nil)
        self.parser = self.format.locale(.en_US_POSIX).parseStrategy
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func transform(_ precision: _NFSC.Precision) {
        self.format = format.precision(precision)
    }
    
    @inlinable mutating func transform(_ sign: Sign) {
        let display = Format._SignDS(sign == .negative ? .always : .automatic)
        self.format = format.sign(strategy: display)
    }
    
    @inlinable mutating func transform(_ separator: Separator?) {
        let display = separator != nil ? _NFSC_SeparatorDS.always : .automatic
        self.format = format.decimalSeparator(strategy:display)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_ value: Format.FormatInput) -> String {
        self.format.format(value)
    }
    
    @inlinable func parse(_ number: Number) throws -> Format.FormatInput {
        try self.parser.parse(number.description)
    }
}
