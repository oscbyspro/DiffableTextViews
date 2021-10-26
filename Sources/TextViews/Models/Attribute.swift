//
//  Attribute.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

// MARK: - Attribute

public struct Attribute: OptionSet {
    public static let content: Self = .init(rawValue: 1 << 0)

    public static let diffableOnInsert: Self = .init(rawValue: 1 << 1)
    public static let diffableOnRemove: Self = .init(rawValue: 1 << 2)
    public static let diffableOnChange: Self = .init(diffableOnInsert, diffableOnRemove)

    public static let directsCaretForwards:  Self = .init(rawValue: 1 << 3)
    public static let directsCaretBackwards: Self = .init(rawValue: 1 << 4)
    public static let directsCaretBothWays:  Self = .init(directsCaretForwards, directsCaretBackwards)

    // MARK: Properties
    
    public let rawValue: UInt8
    
    // MARK: Initializers
        
    @inlinable public init(rawValue: UInt8 = 0) {
        self.rawValue = rawValue
    }
    
    @inlinable public init(_ attributes: Attribute...) {
        self.init(attributes)
    }
    
    // MARK: Comparisons
    
    @inlinable func intersects(with other: Self) -> Bool {
        !isDisjoint(with: other)
    }
    
    // MARK: Components: Intuitive
            
    public struct Intuitive {
        public static let spacer:   Self = .init()
        public static let prefix:   Self = .init(.directsCaretForwards)
        public static let suffix:   Self = .init(.directsCaretBackwards)
        public static let content:  Self = .init(.content, .diffableOnChange)
        
        // MARK: Properties
        
        public let attribute: Attribute
        
        // MARK: Initializers
        
        @inlinable init(_ attribute: Attribute...) {
            self.attribute = .init(attribute)
        }
    }
    
    // MARK: Components: Breakpoints
    
    #warning("...")
    public enum Breakpoints {
        public static let forwards:  Attribute = .init(.content, .directsCaretBackwards)
        public static let backwards: Attribute = .init(.content, .directsCaretForwards)
        public static let bothWays:  Attribute = .init(.content, .directsCaretBothWays)
    }
}
