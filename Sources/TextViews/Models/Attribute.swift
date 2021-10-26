//
//  Attribute.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

// MARK: - Attribute

public struct Attribute: Equatable {
    public typealias Layout = AttributeOfLayout
    public typealias Differentiation = AttributeOfDifferentiation
    
    // MARK: Properties
    
    public var layout: Layout
    public var differentiation: Differentiation
    
    // MARK: Initializers
        
    @inlinable public init(layout: Layout, differentiation: Differentiation) {
        self.layout = layout
        self.differentiation = differentiation
    }
    
    // MARK: Initializers, Static
    
    public static let content: Self = .init(layout: .content, differentiation: .onChange)
    public static let spacer:  Self = .init(layout: .spacer,  differentiation: .none)
    public static let prefix:  Self = .init(layout: .prefix,  differentiation: .none)
    public static let suffix:  Self = .init(layout: .suffix,  differentiation: .none)
    
    // MARK: Transformations
    
    @inlinable public func update(_ transform: (inout Self) -> Void) -> Self {
        var result = self; transform(&result); return result
    }
}

// MARK: - Option Set

public protocol  AttributeOptionSet: OptionSet { }
public extension AttributeOptionSet {
    
    // MARK: Utilities
    
    @inlinable func intersects(_ other: Self) -> Bool {
        !isDisjoint(with: other)
    }
}

// MARK: - Layout

public struct AttributeOfLayout: AttributeOptionSet {
    public static let content: Self = .init(rawValue: 1 << 0)
    public static let prefix:  Self = .init(rawValue: 1 << 1)
    public static let suffix:  Self = .init(rawValue: 1 << 1)
    public static let spacer:  Self = .init()
    
    // MARK: Properties
    
    public let rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable public init(rawValue: UInt8 = 0) {
        self.rawValue = rawValue
    }
    
    @inlinable public init(_ elements: Self...) {
        self.init(elements)
    }
}

// MARK: - Update

public struct AttributeOfDifferentiation: AttributeOptionSet {
    public static let onInsert: Self = .init(rawValue: 1 << 0)
    public static let onRemove: Self = .init(rawValue: 1 << 1)
    public static let onChange: Self = .init(onInsert, onRemove)
    public static let none:     Self = .init()
    
    // MARK: Properties
    
    public let rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable public init(rawValue: UInt8 = 0) {
        self.rawValue = rawValue
    }
    
    @inlinable public init(_ elements: Self...) {
        self.init(elements)
    }
}
