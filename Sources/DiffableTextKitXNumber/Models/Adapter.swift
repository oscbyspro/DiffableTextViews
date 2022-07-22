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
// MARK: * Adapter
//*============================================================================*

@usableFromInline struct Adapter<Format: _Format> {
    @usableFromInline typealias  Parser = Format.Strategy
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let format: Format
    @usableFromInline let parser: Parser
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: Format) {
        self.format = unchecked.rounded(rule: .towardZero, increment: nil)
        self.parser = self.format.locale(Locale.en_US_POSIX).parseStrategy
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_  precision: _NFSC.Precision) -> Format {
        self.format.precision(precision)
    }
    
    @inlinable func parse(_ number: Number) throws -> Format.FormatInput {
        try self.parser.parse(number.description)
    }
}
