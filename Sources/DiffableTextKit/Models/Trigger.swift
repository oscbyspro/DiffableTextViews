//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: Declaration
//*============================================================================*

/// A resettable action stack.
public struct Trigger: ExpressibleByNilLiteral {
    public typealias Action = () -> Void
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var action: Action?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ action: Action?) {
        self.action = action
    }
    
    @inlinable public init(nilLiteral: Void) {
        self.action = nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func callAsFunction() {
        self.action?()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Appends the trigger if it exists, resets this instance otherwise.
    @inlinable public mutating func merge(_ other: Self) {
        if let other = other.action {
            //=----------------------------------=
            // Append
            //=----------------------------------=
            if let this = self.action {
                self.action = { this(); other() }
            //=----------------------------------=
            // Replace
            //=----------------------------------=
            } else { self.action = other }
        //=--------------------------------------=
        // Reset
        //=--------------------------------------=
        } else { self.action = nil }
    }
    
    /// Appends the trigger if it exists, resets this instance otherwise.
    @inlinable public static func &+= (this: inout Self, other: Self) {
        this.merge(other)
    }
}
