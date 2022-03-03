//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Snapshot
//=----------------------------------------------------------------------------=

extension Field {

    //=------------------------------------------------------------------------=
    // MARK: Update
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(snapshot: Snapshot) {
        let layout = Layout(snapshot)
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = Mismatches.suffix(past: self.layout[selection.upperBound...], next: layout).next
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !selection.isEmpty {
            lowerBound = Mismatches.prefix(past: self.layout[..<selection.lowerBound], next: layout).next
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.layout = layout
        self.update(selection: lowerBound ..< upperBound)
    }
}
