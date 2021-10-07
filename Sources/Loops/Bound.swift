//
//  Bound.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

public struct Bound<Element: Comparable>: Comparable {
    // MARK: Properties
    
    public let element: Element
    public let open: Bool
    
    // MARK: Initializers

    @inlinable init(_ element: Element, open: Bool) {
        self.element = element
        self.open = open
    }
    
    @inlinable public static func open(_ element: Element) -> Self {
        Self(element, open: true)
    }
    
    @inlinable public static func closed(_ element: Element) -> Self {
        Self(element, open: false)
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
