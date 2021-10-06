//
//  Bound.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

public struct Bound<Position: Comparable>: Comparable {
    // MARK: Properties
    
    public let position: Position
    public let open: Bool
    
    // MARK: Initializers

    @inlinable init(_ position: Position, open: Bool) {
        self.position = position
        self.open = open
    }
    
    @inlinable public static func open(_ position: Position) -> Self {
        Self(position, open: true)
    }
    
    @inlinable public static func closed(_ position: Position) -> Self {
        Self(position, open: false)
    }
    
    // MARK: Comparable
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.position < rhs.position
    }
    
    // MARK: Comparisons: ==
    
    @inlinable public static func == (bound: Self, position: Position) -> Bool {
        !bound.open && bound.position == position
    }
    
    @inlinable public static func == (position: Position, bound: Self) -> Bool {
        !bound.open && bound.position == position
    }
    
    // MARK: Comparisons: <
    
    @inlinable public static func < (bound: Self, position: Position) -> Bool {
        bound.position < position
    }
    
    @inlinable public static func < (position: Position, bound: Self) -> Bool {
        position > bound.position
    }
    
    // MARK: Comparisons: <=
    
    @inlinable public static func <= (bound: Self, position: Position) -> Bool {
        bound.open ? bound.position < position : bound.position <= position
    }
    
    @inlinable public static func <= (position: Position, bound: Self) -> Bool {
        bound.open ? position < bound.position : position <= bound.position
    }
    
    // MARK: Comparisons: >
    
    
    @inlinable public static func > (bound: Self, position: Position) -> Bool {
        bound.position > position
    }
    
    @inlinable public static func > (position: Position, bound: Self) -> Bool {
        position > bound.position
    }
    
    // MARK: Comparisons: >=
    
    @inlinable public static func >= (bound: Self, position: Position) -> Bool {
        bound.open ? bound.position > position : bound.position >= position
    }
    
    @inlinable public static func >= (position: Position, bound: Self) -> Bool {
        bound.open ? position > bound.position : position >= bound.position
    }
}
