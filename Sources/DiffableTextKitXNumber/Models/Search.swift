//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Search
//*============================================================================*

/// A naive search for targets at or near a known edge of a collection.
@usableFromInline enum Search<Source, Target> where
Source: BidirectionalCollection, Source.Element == Symbol,
Target: BidirectionalCollection, Target.Element == Character {
    
    //=------------------------------------------------------------------------=
    // MARK: Adaptive
    //=------------------------------------------------------------------------=
    
    @inlinable static func range(
    of target: Target, in source: Source, towards
    direction: Direction) -> Range<Source.Index>? {
        switch direction {
        case  .forwards: return  forwards(search: source, locate: target)
        case .backwards: return backwards(search: source, locate: target)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    @inlinable static func forwards(search source: Source,
    locate target: Target) -> Range<Source.Index>? {
        //=--------------------------------------=
        // Search
        //=--------------------------------------=
        search: for start in source.indices {
            var end = start
            
            for character in target {
                guard end != source.endIndex,
                character == source[end].character
                else { continue search }
                
                source.formIndex(after: &end)
            }
            //=----------------------------------=
            // Some
            //=----------------------------------=
            return start ..< end
        }
        //=--------------------------------------=
        // None
        //=--------------------------------------=
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    @inlinable static func backwards(search source: Source,
    locate target: Target) -> Range<Source.Index>? {
        typealias R = Search<
        ReversedCollection<Source>,
        ReversedCollection<Target>>
        
        let reversed = R.forwards(
        search: source.reversed(),
        locate: target.reversed())
        
        return reversed.map({ $0.upperBound.base ..< $0.lowerBound.base })
    }
}
