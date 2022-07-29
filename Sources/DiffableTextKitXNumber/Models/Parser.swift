//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Parser
//*============================================================================*

@usableFromInline struct Parser<Format: _Format> {
    @usableFromInline typealias Value = Format.FormatInput

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Format.Strategy
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(initial: Format) {
        self.base = initial.locale(.en_US_POSIX).parseStrategy
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func parse(_ number: Number) throws -> Value {
        try base.parse(String(bytes: number.ascii, encoding: .ascii)!)
    }
}
