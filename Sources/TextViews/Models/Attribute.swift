//
//  Attribute.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

// MARK: - Attribute

#warning("Make it so spacer is an empty attribute, because that makes the most sense.")
public struct Attribute: OptionSet {
    public static let real: Self = .init(rawValue: 1 << 0)

    public static let diffableOnInsert: Self = .init(rawValue: 1 << 1)
    public static let diffableOnRemove: Self = .init(rawValue: 1 << 2)
    public static let diffableOnChange: Self = .init(diffableOnInsert, diffableOnRemove)

    public static let directsCaretForwards:  Self = .init(rawValue: 1 << 3)
    public static let directsCaretBackwards: Self = .init(rawValue: 1 << 4)
    public static let directsCaretBothWays:  Self = .init(directsCaretForwards, directsCaretBackwards)

    public static let markAlpha: Self = .init(rawValue: 1 << 5)
    public static let markBeta:  Self = .init(rawValue: 1 << 6)
    public static let markGamma: Self = .init(rawValue: 1 << 7)

    
    // MARK: Properties
    
    public let rawValue: UInt8
    
    // MARK: Initializers
        
    @inlinable public init(rawValue: UInt8 = 0) {
        self.rawValue = rawValue
    }
    
    @inlinable public init(_ attributes: Attribute...) {
        self.init(attributes)
    }
    
    // MARK: Utilities
    
    @inlinable func intersects(with other: Self) -> Bool {
        !isDisjoint(with: other)
    }
    
    // MARK: Composites
    
    #warning("Remove, maybe.")
    public static let spacer:  Attribute = .init()
    public static let prefix:  Attribute = .init(directsCaretForwards)
    public static let suffix:  Attribute = .init(directsCaretBackwards)
    public static let content: Attribute = .init(real, diffableOnChange)
    
    #warning("Remove, maybe")
    public static let breakpointForwards: Attribute = .init(real, directsCaretBackwards)
    public static let breakpointBackwards: Attribute = .init(real, directsCaretForwards)
    public static let breakpointBothWays: Attribute = .init(real, directsCaretBothWays)
}
