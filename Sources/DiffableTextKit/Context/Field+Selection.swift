//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Selection
//=----------------------------------------------------------------------------=

extension Field {
    
    //=------------------------------------------------------------------------=
    // MARK: Update
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(selection: Range<Position>, momentum: Bool) {
        let selection = indices(at: selection)
        //=--------------------------------------=
        // MARK: Parse Mementum As Intent
        //=--------------------------------------=
        let momentum = momentum ? Momentum(self.selection, to: selection) : Momentum()
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.update(selection: selection, momentum: momentum)
    }
    
    @inlinable mutating func update(selection: Range<Layout.Index>, momentum: Momentum = Momentum()) {
        self.selection = selection
        //=--------------------------------------=
        // MARK: Exceptions
        //=--------------------------------------=
        if selection == layout.range { return }
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        self.selection = layout.preferred(selection, momentum: momentum)
    }
}
