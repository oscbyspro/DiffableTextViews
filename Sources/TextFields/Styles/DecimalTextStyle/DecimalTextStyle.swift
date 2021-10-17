//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-28.
//

import SwiftUI

#if os(iOS)

#warning("Should not trim trailing zeros, only on editing changed.")
#warning("Can't write 0.005, because it's not possible to add trailing decimal zeros.")
@available(iOS 15.0, *)
public struct DecimalTextStyle: DiffableTextStyle {
    @usableFromInline typealias Base = Decimal.FormatStyle
    @usableFromInline typealias BasePrecisionStrategy = Base.Configuration.Precision
    @usableFromInline typealias BaseSeparatorStrategy = Base.Configuration.DecimalSeparatorDisplayStrategy
    @usableFromInline typealias Components = DecimalTextComponents

    public typealias Values = DecimalTextValues
    public typealias Precision = DecimalTextPrecision

    // MARK: Properties
    
    @usableFromInline var base: Base
    @usableFromInline var values: Values = .all
    @usableFromInline var precision: Precision = .max
        
    // MARK: Initializers
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.base = Base(locale: locale)
    }
    
    // MARK: Styles
    
    @inlinable func displayableStyle() -> Base {
        base.precision(precision.displayableStyle())
    }
    
    @inlinable func editableStyle(decimal: Bool = false) -> Base {
        base.precision(precision.editableStyle()).decimalSeparator(strategy: decimal ? .always : .automatic)
    }
    
    // MARK: Maps
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        map({ $0.base = $0.base.locale(locale) })
    }
    
    @inlinable public func precision(_ newValue: Precision) -> Self {
        map({ $0.precision = newValue })
    }
    
    @inlinable public func values(_ newValue: Values) -> Self {
        map({ $0.values = newValue })
    }

    // MARK: Helpers
    
    @inlinable func map(_ transform: (inout Self) -> Void) -> Self {
        var copy = self; transform(&copy); return copy
    }
}

// MARK: DecimalTextStyle: Getters

@available(iOS 15.0, *)
extension DecimalTextStyle {
    
    // MARK: Localization
    
    @inlinable var locale: Locale {
        base.locale
    }
    
    @inlinable var decimalSeparator: String {
        locale.decimalSeparator ?? "."
    }
    
    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? ","
    }
    
    // MARK: Sets
    
    @inlinable var minus: String? {
        !values.nonnegative ? Components.sign : nil
    }
    
    @inlinable func content() -> Set<Character> {
        var set = Set<Character>()
        set.formUnion(Components.sign)
        set.formUnion(Components.digits)
        set.formUnion(decimalSeparator)
        return set
    }
    
    @inlinable func spacers() -> Set<Character> {
        var set = Set<Character>()
        set.formUnion(groupingSeparator)
        return set
    }
}

// MARK: DecimalTextStyle: DiffableTextStyle

@available(iOS 15.0, *)
extension DecimalTextStyle {
    
    // MARK: Snapshot
        
    @inlinable public func showcase(_ value: Decimal) -> Snapshot {
        let style = displayableStyle()
        
        return snapshot(style.format(value))
    }
    
    @inlinable public func snapshot(_ value: Decimal) -> Snapshot {
        let style = editableStyle()
        
        return snapshot(style.format(value))
    }
        
    // MARK: Parse

    @inlinable public func parse(_ snapshot: Snapshot) -> Decimal? {
        guard !snapshot.isEmpty else {
            return 0
        }
        
        guard let components = components(snapshot) else {
            return nil
        }

        return components.decimal()
    }
    
    // MARK: Process
    
    @inlinable public func process(_ snapshot: Snapshot) -> Snapshot? {
        guard let components = components(snapshot) else {
            return nil
        }
        
        // validate components
        
        guard values.min < 0 || components.sign.isEmpty else {
            return nil
        }
                
        if components.integerDigits.isEmpty, components.decimalSeparator.isEmpty, components.decimalDigits.isEmpty {
            return Snapshot(components.characters(), only: .content)
        }
                                
        guard precision.validate(editable: components) else {
            return nil
        }
        
        // style
        
        let style = editableStyle(decimal: !components.decimalSeparator.isEmpty)

        // decimal
        
        guard let decimal = components.decimal() else {
            return nil
        }
        
        guard values.contains(decimal) else {
            return nil
        }
        
        // characters
        
        var characters = style.format(decimal)
        
        if !components.sign.isEmpty, !characters.hasPrefix(components.sign) {
            characters = components.sign + characters
        }
        
        print(components.characters(), characters)
        
        // return
        
        return self.snapshot(characters)
    }
    
    // MARK: Helpers
    
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        var snapshot = Snapshot()
        
        let contentSet = content()
        let spacersSet = spacers()
        
        for character in characters {
            if contentSet.contains(character) {
                snapshot.append(.content(character))
            } else if spacersSet.contains(character) {
                snapshot.append(.spacer(character))
            }
        }
        
        return snapshot
    }
    
    @inlinable func components(_ snapshot: Snapshot) -> Components? {
        var characters = snapshot.content()
        characters = characters.replacingOccurrences(of: decimalSeparator, with: Components.decimalSeparator)
        return DecimalTextComponents(from: characters)
    }
}

#endif
