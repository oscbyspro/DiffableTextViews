//
//  DecimalAdapter.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-28.
//

import Foundation

#warning("WIP")
public struct DecimalAdapter: Adapter {
    let formatter: NumberFormatter
    
    public init() {
        #warning("TODO.")
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        formatter.maximumIntegerDigits = Self.maximumNumberOfDigits
        formatter.maximumFractionDigits = Self.maximumNumberOfDigits
        formatter.roundingMode = .down
        formatter.groupingSeparator = " "
        self.formatter = formatter
    }
    
    public func parse(content: String) throws -> Decimal {
        let parseable = content.replacingOccurrences(of: formatter.decimalSeparator, with: ".")
        
        guard let decimal = Decimal(string: parseable) else {
            throw ParseFailure()
        }
        
        return decimal
    }
    
    public func transcribe(value: Decimal) -> String {
        String(describing: value).replacingOccurrences(of: ".", with: formatter.decimalSeparator)
    }
    
    public func snapshot(content: String) -> Snapshot {
        var snapshot = Snapshot()
        
        guard let decimal: Decimal = try? parse(content: content) else {
            return snapshot
        }
        
        guard let formatted: String = formatter.string(from: decimal as NSDecimalNumber) else {
            return snapshot
        }
                
        let content = characters()
        let spacers = spacers()
        
        for character in formatted {
            if content.contains(character) {
                snapshot.append(.content(character))
            } else if spacers.contains(character) {
                snapshot.append(.spacer(character))
            }
        }
        
        return snapshot
    }
    
    struct ParseFailure: Error { }
}

// MARK: - Constants

extension DecimalAdapter {
    static let maximumNumberOfDigits: Int = 38
    static let maximumAbsoluteValue = Decimal(string: String(repeating: "9", count: maximumNumberOfDigits))!
    
    static let digits = Set<Character>("0123456789")
    static let decimalSeparator: Character = "."
    static let minus: Character = "-"
    
    func characters() -> Set<Character> {
        Self.digits.union([Character(formatter.decimalSeparator), Character(formatter.negativePrefix)])
    }
    
    func spacers() -> Set<Character> {
        Set([Character(formatter.groupingSeparator)])
    }
}
