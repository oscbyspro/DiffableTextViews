//
//  Positions.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

@usableFromInline struct Positions: BidirectionalCollection {
    @usableFromInline let format: Format
    @usableFromInline let prefix: Format.Element
    @usableFromInline let suffix: Format.Element

    // MARK: Initializers
    
    /// - Complexity: O(1).
    @inlinable init(_ format: Format = Format()) {
        self.format = format
        self.prefix = Symbol("<", attribute: .prefix)
        self.suffix = Symbol(">", attribute: .suffix)
    }
    
    // MARK: BidirectionalCollection

    /// - Complexity: O(1).
    @inlinable var startIndex: Index {
        Index(start: nil, end: format.startIndex)
    }

    /// - Complexity: O(1).
    @inlinable var endIndex: Index {
        Index(start: format.endIndex, end: nil)
    }

    /// - Complexity: O(1).
    @inlinable func index(after i: Index) -> Index {
        Index(start: i.end!, end: optionalIndex(after: i.end!))
    }

    /// - Complexity: O(1).
    @inlinable func index(before i: Index) -> Index {
        Index(start: optionalIndex(before: i.start!), end: i.start!)
    }

    /// - Complexity: O(1).
    @inlinable subscript(position: Index) -> Element {
        _read {
            yield Element(start: attribute(at: position.start) ?? prefix, end: attribute(at: position.end) ?? suffix)
        }
    }

    // MARK: Interoperabilities

    /// - Complexity: O(1).
    @usableFromInline func index(start: Format.Index) -> Index {
        Index(start: start, end: optionalIndex(after: start))
    }

    /// - Complexity: O(1).
    @usableFromInline func index(end: Format.Index) -> Index {
        Index(start: optionalIndex(before: end), end: end)
    }

    // MARK: Helpers

    /// - Complexity: O(1).
    @inlinable func attribute(at index: Format.Index?) -> Format.Element? {
        guard let index = index, index < format.endIndex else {
            return nil
        }

        return format[index]
    }

    /// - Complexity: O(1).
    @inlinable func optionalIndex(after index: Format.Index) -> Format.Index? {
        guard index < format.endIndex else {
            return nil
        }

        return format.index(after: index)
    }

    /// - Complexity: O(1).
    @inlinable func optionalIndex(before index: Format.Index) -> Format.Index? {
        guard index > format.startIndex else {
            return nil
        }

        return format.index(before: index)
    }

    // MARK: Components

    @usableFromInline struct Element {
        @usableFromInline let start: Format.Element
        @usableFromInline let end: Format.Element
        
        /// - Complexity: O(1).
        @inlinable init(start: Format.Element, end: Format.Element) {
            self.start = start
            self.end = end
        }
    }

    @usableFromInline struct Index: Comparable {
        @usableFromInline let start: Format.Index?
        @usableFromInline let end: Format.Index?

        /// - Complexity: O(1).
        @inlinable init(start: Format.Index?, end: Format.Index?) {
            self.start = start
            self.end = end
            assert(start != nil || end != nil)
        }
        
        /// - Complexity: O(1).
        @inlinable var offset: Int {
            start.map({ $0.offset + 1 }) ?? 0
        }

        /// - Complexity: O(1).
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.offset < rhs.offset
        }
    }
}
