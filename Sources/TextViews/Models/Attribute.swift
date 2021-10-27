//
//  Attribute.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

// MARK: - Attribute

/// A set of options, where each option represents a specialized behavior.
///
/// - Ordinary text equals 0.
public struct Attribute: OptionSet {
    public static let format: Self = .init(rawValue: 1 << 0)
    public static let prefix: Self = .init(rawValue: 1 << 1)
    public static let suffix: Self = .init(rawValue: 1 << 2)
    public static let insert: Self = .init(rawValue: 1 << 3)
    public static let remove: Self = .init(rawValue: 1 << 4)
    
    // MARK: Properties
    
    public let rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable public init(rawValue: UInt8 = .zero) {
        self.rawValue = rawValue
    }
    
    @inlinable public init(_ attributes: Self...) {
        self.init(attributes)
    }
    
    // MARK: Utilities

    @inlinable public func update(_ transform: (inout Self) -> Void) -> Self {
        var result = self; transform(&result); return result
    }
    
    // MARK: Components: Composites
    
    public enum Sets {
        public static let nondiffable: Attribute = .init(.insert, .remove)
        public static let nonreal: Attribute = .init(.format, nondiffable)
    }
    
    public enum Layout {
        public static let content: Attribute = .init()
        public static let prefix:  Attribute = .init(Sets.nonreal, .prefix)
        public static let suffix:  Attribute = .init(Sets.nonreal, .suffix)
        public static let spacer:  Attribute = .init(Sets.nonreal, .prefix, .suffix)
    }
}

// MARK: - Symbol + Attribute

extension Symbol {
    @inlinable static func contains(_ attribute: Attribute, is option: Bool = true) -> (Self) -> Bool {
        func yes(symbol: Self) -> Bool {  symbol.attribute.contains(attribute) }
        func  no(symbol: Self) -> Bool { !symbol.attribute.contains(attribute) }

        return option ? yes : no
    }
}

// MARK: - Carets.Element + Attribute

extension Carets.Element {
    @inlinable static func symbol(_ symbol: @escaping (Self) -> Symbol, contains attribute: Attribute, is option: Bool = true) -> (Self) -> Bool {
        func yes(element: Self) -> Bool {  symbol(element).attribute.contains(attribute) }
        func  no(element: Self) -> Bool { !symbol(element).attribute.contains(attribute) }

        return option ? yes : no
    }
}
