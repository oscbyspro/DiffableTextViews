//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Peek
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Ahead
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(ahead position: Index) -> Index? {
        position != endIndex ? position : nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Behind
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(behind position: Index) -> Index? {
        position != startIndex ? index(before: position) : nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Ahead / Behind
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(_ position: Index, direction: Direction) -> Index? {
        direction == .forwards ? peek(ahead: position) : peek(behind: position)
    }
}
