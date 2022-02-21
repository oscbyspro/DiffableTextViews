//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Foundation
import Support

//*============================================================================*
// MARK: * NumericTextStyle
//*============================================================================*

public struct NumericTextStyle<Format: NumericTextFormat>: DiffableTextStyle {
    public typealias Value = Format.FormatInput
    public typealias Specialization = Format.Specialization
    public typealias Bounds = NumericTextStyles.Bounds<Value>
    public typealias Precision = NumericTextStyles.Precision<Value>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let format: Format
    @usableFromInline var specialization: Specialization
    
    @usableFromInline var bounds: Bounds
    @usableFromInline var precision: Precision
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ format: Format) {
        self.format = format
        self.specialization = Format.specialization(format)
        self.bounds = Bounds()
        self.precision = Precision()
        #warning("Move this assertion somewhere else.")
        assert(format.locale == specialization.lexicon.locale)
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale {
        format.locale
    }
    
    @inlinable var lexicon: Lexicon {
        specialization.lexicon
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    #error("FIXME")
    @inlinable public func locale(_ locale: Locale) -> Self {
        guard self.locale != locale else { return self }
        var result = self; result.adapter = specialization.locale(locale); return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Equatable
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.format    == rhs.format   else { return false }
        guard lhs.bounds    == rhs.bounds    else { return false }
        guard lhs.precision == rhs.precision else { return false }
        return true
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Format
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Value) -> String {
        format.precision(precision.inactive()).format(value)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Interpret
    //=------------------------------------------------------------------------=
    
    @inlinable public func interpret(_ value: Value) -> Commit<Value> {
        var style = format.precision(precision.active())
        var value = value
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&value)
        //=--------------------------------------=
        // MARK: Value -> Components
        //=--------------------------------------=
        let formatted = style.format(value)
        let parseable = snapshot(formatted)
        var components = try! components(parseable)
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&components.sign)
        precision.autocorrect(&components)
        //=--------------------------------------=
        // MARK: Value <- Components
        //=--------------------------------------=
        value = try! self.value(components)
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        style = style.sign(self.sign(components))
        //=--------------------------------------=
        // MARK: Characters
        //=--------------------------------------=
        var characters = style.format(value)
        fix(components.sign, for: value, in: &characters)
        //=--------------------------------------=
        // MARK: Snapshot -> Commit
        //=--------------------------------------=
        return Commit(value, snapshot(characters))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Downstream
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Merge
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(_ changes: Changes) throws -> Commit<Value> {
        var reader = Reader(changes, in: lexicon)
        //=--------------------------------------=
        // MARK: Reader
        //=--------------------------------------=
        reader.translateSingleCharacterInput()
        let sign = reader.consumeSingleSignInput()
        let proposal = reader.changes.proposal()
        //=--------------------------------------=
        // MARK: Components
        //=--------------------------------------=
        var components = try components(proposal)
        components.set(sign)
        //=--------------------------------------=
        // MARK: Components - Validate
        //=--------------------------------------=
        try bounds.validate(components.sign)
        //=--------------------------------------=
        // MARK: Components - Count, Capacity
        //=--------------------------------------=
        let count = components.count()
        let capacity = try precision.capacity(count)
        components.removeSeparatorAsSuffixAtZeroCapacity(capacity)
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = try self.value(components)
        //=--------------------------------------=
        // MARK: Value - Validate
        //=--------------------------------------=
        let location = try bounds.validate(value)
        try bounds.validate(components, with: location)
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        let style = format.precision(self.precision.interactive(count))
        .separator(self.separator(components)).sign(self.sign(components))
        //=--------------------------------------=
        // MARK: Characters
        //=--------------------------------------=
        var characters = style.format(value)
        fix(components.sign, for: value, in: &characters)
        //=--------------------------------------=
        // MARK: Snapshot -> Commit
        //=--------------------------------------=
        return Commit(value, snapshot(characters))
    }
}
