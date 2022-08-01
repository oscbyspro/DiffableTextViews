//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Jump [...]
//*============================================================================*

@frozen @usableFromInline enum Jump { case to, through }

//*============================================================================*
// MARK: * Jump x Collection
//*============================================================================*

extension Collection {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func index(from position: Index, forwards distance: Jump,
    targeting target: (Element) -> Bool) -> Index? { switch distance {
        case .to:      return index(from: position, forwardsTo:      target)
        case .through: return index(from: position, forwardsThrough: target) }
    }
    
    @inlinable @inline(__always) func index(
    from position: Index, forwardsTo target: (Element) -> Bool) -> Index? {
        self[position...].firstIndex(where: target)
    }
    
    @inlinable @inline(__always) func index(
    from position: Index, forwardsThrough target: (Element) -> Bool) -> Index? {
        index(from: position, forwardsTo: target).map(index(after:))
    }
}

//*============================================================================*
// MARK: * Jump x Collection x Bidirectional
//*============================================================================*

extension BidirectionalCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
        
    @inlinable func index(from position: Index, towards direction: Direction,
    jumping distance: Jump, targeting target: (Element) -> Bool) -> Index? { switch direction {
        case  .forwards: return index(from: position,  forwards: distance, targeting: target)
        case .backwards: return index(from: position, backwards: distance, targeting: target) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func index(from position: Index, backwards distance: Jump,
    targeting target: (Element) -> Bool) -> Index? { switch distance {
        case .to:      return index(from: position, backwardsTo:      target)
        case .through: return index(from: position, backwardsThrough: target) }
    }
    
    @inlinable @inline(__always) func index(
    from position: Index, backwardsTo target: (Element) -> Bool) -> Index? {
        index(from: position, backwardsThrough: target).map(index(after:))
    }
    
    @inlinable @inline(__always) func index(
    from position: Index, backwardsThrough target: (Element) -> Bool) -> Index? {
        self[..<position].lastIndex(where: target)
    }
}
