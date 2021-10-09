//
//  Bound.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

// MARK: - Bound

public struct Bound<Element: Comparable>: Comparable {
    // MARK: Properties
    
    public let element: Element
    public let open: Bool
    
    // MARK: Initializers

    @inlinable init(_ element: Element, open: Bool) {
        self.element = element
        self.open = open
    }
    
    // MARK: Initializers: Static
    
    @inlinable public static func open(_ element: Element) -> Self {
        Self(element, open: true)
    }
    
    @inlinable public static func closed(_ element: Element) -> Self {
        Self(element, open: false)
    }
    
    // MARK: Conveniences
    
    @inlinable public var closed: Bool {
        !open
    }
    
    // MARK: Comparable
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.element < rhs.element
    }
    
    // MARK: Comparisons: ==
    
    @inlinable public static func == (bound: Self, element: Element) -> Bool {
        !bound.open && bound.element == element
    }
    
    @inlinable public static func == (element: Element, bound: Self) -> Bool {
        !bound.open && bound.element == element
    }
    
    // MARK: Comparisons: !=
    
    @inlinable public static func != (bound: Self, element: Element) -> Bool {
        bound.open || bound.element != element
    }
    
    @inlinable public static func != (element: Element, bound: Self) -> Bool {
        bound.open || bound.element != element
    }
    
    // MARK: Comparisons: <
    
    @inlinable public static func < (bound: Self, element: Element) -> Bool {
        bound.element < element
    }
    
    @inlinable public static func < (element: Element, bound: Self) -> Bool {
        element > bound.element
    }
    
    // MARK: Comparisons: <=
    
    @inlinable public static func <= (bound: Self, element: Element) -> Bool {
        bound.open ? bound.element < element : bound.element <= element
    }
    
    @inlinable public static func <= (element: Element, bound: Self) -> Bool {
        bound.open ? element < bound.element : element <= bound.element
    }
    
    // MARK: Comparisons: >
    
    
    @inlinable public static func > (bound: Self, element: Element) -> Bool {
        bound.element > element
    }
    
    @inlinable public static func > (element: Element, bound: Self) -> Bool {
        element > bound.element
    }
    
    // MARK: Comparisons: >=
    
    @inlinable public static func >= (bound: Self, element: Element) -> Bool {
        bound.open ? bound.element > element : bound.element >= element
    }
    
    @inlinable public static func >= (element: Element, bound: Self) -> Bool {
        bound.open ? element > bound.element : element >= bound.element
    }
}

// MARK: - IndexBound

public struct IndexBound<Base: Collection> {
    public typealias Index = Base.Index
    public typealias Bound = Sequences.Bound<Base.Index>
    
    // MARK: Properties
    
    @usableFromInline let make: (Base) -> Bound
    
    // MARK: Initilizers
    
    @inlinable public init(_ make: @escaping (Base) -> Bound) {
        self.make = make
    }
    
    // MARK: Initializers: Static
    
    @inlinable public static func open(_ index: Index) -> Self {
        .init({ collection in .open(index) })
    }
    
    @inlinable public static func closed(_ index: Index) -> Self {
        .init({ collection in .closed(index) })
    }
    
    @inlinable public static func open(_ index: @escaping (Base) -> Index) -> Self {
        .init({ collection in .open(index(collection)) })
    }
    
    @inlinable public static func closed(_ index: @escaping (Base) -> Index) -> Self {
        .init({ collection in .closed(index(collection)) })
    }
    
    // MARK: Conveniences
    
    @inlinable public func callAsFunction(_ collection: Base) -> Bound {
        make(collection)
    }
}
