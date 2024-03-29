//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Parser [...]
//*============================================================================*

@usableFromInline struct Parser<Format: _Format> {
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Format.Strategy
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(initial: Format) {
        self.base = initial.locale(.en_US_POSIX).parseStrategy
    }
        
    @inlinable func parse(_ number: Number) throws -> Format.FormatInput {
        try base.parse(String.init(bytes: number.ascii, encoding: .ascii)!)
    }
}
