//
//  Number.swift
//
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import DiffableTextViews

//*============================================================================*
// MARK: * Number
//*============================================================================*

/// A system representation of a number.
@usableFromInline struct Number: Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let zero: Self = {
        var instance = Self(); instance.integer = .zero; return instance
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline var sign = Sign()
    @usableFromInline private(set) var integer = Digits()
    @usableFromInline private(set) var separator: Separator? = nil
    @usableFromInline private(set) var fraction = Digits()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
        
    @inlinable func significantCount() -> Int {
        let significantIntegerCount = integer.count - integer.prefixZerosCount()
        var significantFractionCount = fraction.count - fraction.suffixZerosCount()
        
        if significantIntegerCount == 0, significantFractionCount != 0 {
            significantFractionCount = significantFractionCount - fraction.prefixZerosCount()
        }
        
        return significantIntegerCount + significantFractionCount
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func removeImpossibleSeparator(capacity: Capacity) {
        guard fraction.digits.isEmpty else { return }
        guard capacity.fraction <= 0 || capacity.significant <= 0 else { return }
        separator = nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Write
    //=------------------------------------------------------------------------=
    
    @inlinable func write<Stream: TextOutputStream>(characters: inout Stream) {
        sign.write(characters: &characters)
        integer.write(characters: &characters)
        separator?.write(characters: &characters)
        fraction.write(characters: &characters)
    }

    @inlinable func write<Stream: TextOutputStream>(characters: inout Stream, in region: Region) {
        sign.write(characters: &characters, in: region)
        integer.write(characters: &characters, in: region)
        separator?.write(characters: &characters, in: region)
        fraction.write(characters: &characters, in: region)
    }    
}

//=----------------------------------------------------------------------------=
// MARK: Number - CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Number: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable var description: String {
        characters()
    }
}

//=----------------------------------------------------------------------------=
// MARK: Number - Parse
//=----------------------------------------------------------------------------=

extension Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    /// Parses the value represented by a snapshot.
    ///
    /// To use this method, all formatting characters must be marked as formatting.
    ///
    @inlinable init<Value: NumericTextStyles.Value>(_ snapshot: Snapshot, in region: Region, as value: Value.Type) throws {
        guard let start = snapshot.firstIndex(where: { !$0.attribute.contains(.formatting) }) else { self = .zero; return }
        
        //=--------------------------------------=
        // MARK: State
        //=--------------------------------------=
        
        var index = start
        var element = snapshot[start]
        
        //=--------------------------------------=
        // MARK: Helpers
        //=--------------------------------------=

        func next() {
            while true {
                snapshot.formIndex(after: &index)
                if index == snapshot.endIndex { break }
                element = snapshot[index]
                if !element.attribute.contains(.formatting) { break }
            }
        }
        
        attempt: do {

            //=----------------------------------=
            // MARK: Sign
            //=----------------------------------=

            if index != snapshot.endIndex, !Value.isUnsigned, let sign = region.signs[element.character] {
                self.sign = sign
                next()
            }

            //=----------------------------------=
            // MARK: Digits
            //=----------------------------------=

            while index != snapshot.endIndex, let digit = region.digits[element.character] {
                self.integer.append(digit)
                next()
            }
            
            self.integer.removeZerosPrefix()
            self.integer.makeItAtLeastZero()
            
            guard !Value.isInteger else { break attempt }
            
            //=----------------------------------=
            // MARK: Separator
            //=----------------------------------=

            if index != snapshot.endIndex, let _ = region.separators[element.character] {
                self.separator = .fraction
                next()
            }
            
            guard self.separator == .fraction else { break attempt }
            
            //=----------------------------------=
            // MARK: Fraction
            //=----------------------------------=
            
            while index != snapshot.endIndex, let digit = region.digits[element.character] {
                self.fraction.append(digit)
                next()
            }
            
        }
        
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        
        guard index == snapshot.endIndex else {
            throw Info(["unable to parse number in", .mark(snapshot.characters)])
        }
    }
}
