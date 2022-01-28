//
//  Equals.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-28.
//

//*============================================================================*
// MARK: * Equals
//*============================================================================*

public struct Equals<Style: DiffableTextStyle, Equatable: Swift.Equatable>: Wrapper {
    public typealias Value = Style.Value

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    public var style: Style
    public let equatable: Equatable

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) init(style: Style, equatable: Equatable) {
        self.style = style
        self.equatable = equatable
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func make(style: Style) -> Self {
        Self(style: style, equatable: equatable)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public static func == (lhs: Self, rhs: Self) -> Bool { true }
}

//=----------------------------------------------------------------------------=
// MARK: Equals - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension Equals: UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

#endif

//*============================================================================*
// MARK: * DiffableTextStyle x Equals
//*============================================================================*

extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func equals<T: Equatable>(_ equatable: T) -> Equals<Self, T> {
        Equals(style: self, equatable: equatable)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations - Combine
    //=------------------------------------------------------------------------=
    
    @inlinable public func equals(combine hashables: AnyHashable...) -> Equals<Self, Int> {
        var hasher = Hasher()
        //=--------------------------------------=
        // MARK: Combine
        //=--------------------------------------=
        for hashable in hashables { hasher.combine(hashable) }
        //=--------------------------------------=
        // MARK: Finalize
        //=--------------------------------------=
        return Equals(style: self, equatable: hasher.finalize())
    }
}
