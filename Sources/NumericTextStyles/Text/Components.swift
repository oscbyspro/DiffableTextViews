//
//  Components.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

// MARK: - Components

@usableFromInline struct Components {
    
    // MARK: Properties

    @usableFromInline var sign: Sign?
    @usableFromInline var integers: Digits
    @usableFromInline var separator: Separator?
    @usableFromInline var decimals: Digits
    
    // MARK: Initializers
    
    @inlinable init() {
        self.sign = nil
        self.integers = .init()
        self.separator = nil
        self.decimals = .init()
    }

    // MARK: Utilities
        
    @inlinable func characters() -> String {
        [sign?.characters, integers.characters, separator?.characters, decimals.characters].compactMap({ $0 }).joined()
    }
    
    // MARK: Transformations
    
    @inlinable mutating func toggleSign(with proposal: Sign) {
        if sign != proposal { sign = proposal } else { sign = nil }
    }
    
    // MARK: Components: Sign
    
    @usableFromInline enum Sign: String {
        @usableFromInline static let set = Set<Character>(plus + minus)
        @inlinable static var plus:  String { positive.characters }
        @inlinable static var minus: String { negative.characters }
        
        case positive = "+"
        case negative = "-"
        
        @inlinable var characters: String { rawValue }
    }
    
    // MARK: Components: Separator
    
    @usableFromInline struct Separator {
        @usableFromInline static let system = Separator(characters: ".")
        
        // MARK: Properties
        
        public let characters: String
        
        // MARK: Initializers
        
        @inlinable init(characters: String) {
            self.characters = characters
        }
    }
    
    // MARK: Components: Digits
    
    @usableFromInline struct Digits {
        @usableFromInline static let zero: Character = "0"
        @usableFromInline static let set = Set<Character>("0123456789")
        
        // MARK: Properties
        
        @usableFromInline var count: Int = 0
        @usableFromInline var characters: String = ""
        
        // MARK: Initializers
        
        @inlinable init() { }
        
        // MARK: Transformations
        
        @inlinable mutating func append(_ character: Character) {
            count += 1
            characters.append(character)
        }
        
        // MARK: Descriptions
        
        @inlinable var isZero: Bool {
            characters == String(Self.zero)
        }
        
        @inlinable var equalsZero: Bool {
            characters.allSatisfy(digitIsZero)
        }
        
        @inlinable var isEmpty: Bool {
            characters.isEmpty
        }
        
        @inlinable func numberOfZerosAsPrefix() -> Int {
            characters.prefix(while: digitIsZero).count
        }
        
        @inlinable func numberOfZerosAsSuffix() -> Int {
            characters.reversed().prefix(while: digitIsZero).count
        }
        
        // MARK: Helpers
        
        @inlinable func digitIsZero(_ character: Character) -> Bool {
            character == Self.zero
        }
    }
}

// MARK: - Descriptions: Numer Of Digits

extension Components {
    
    // MARK: Total
    
    @inlinable func numberOfDigits() -> _Count {
        .init(integer: integers.count, fraction: decimals.count)
    }
    
    @inlinable func numberOfDigitsIgnoringSingleIntegerZero() -> _Count {
        .init(integer: integers.isZero ? .zero : integers.count, fraction: decimals.count)
    }
    
    // MARK: Significands
        
    @inlinable func numberOfSignificands() -> _Count {
        .init(integer: integers.count - integers.numberOfZerosAsPrefix(), fraction: decimals.count - decimals.numberOfZerosAsSuffix())
    }
}
