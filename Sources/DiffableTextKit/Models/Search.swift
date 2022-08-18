//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Search
//*============================================================================*

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Range x Forwards, Backwards
    //=------------------------------------------------------------------------=
    
    /// - Can use Collection/firstRange(of:) in iOS 16+
    @inlinable public func range(of text: some StringProtocol, first direction: Direction) -> Range<Index>? {
        let options: String.CompareOptions = ( direction == .forwards) ? [] : [.backwards]
        guard var range = characters.range(of: text, options: options) else { return nil }
        range = characters.rangeOfComposedCharacterSequences(for: range) /*-------------*/
        let lower = Index(range.lowerBound, as: characters[/**/..<range.lowerBound].count)
        let upper = Index(range.upperBound, as: lower.attribute + characters[range].count)
        return Range(uncheckedBounds: (lower, upper))
    }
}
