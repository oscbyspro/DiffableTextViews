//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

#warning("WIP")
#warning("WIP")
#warning("WIP")

//*============================================================================*
// MARK: * Default x Measurement
//*============================================================================*

public struct _MeasurementStyle<Unit: Dimension>: _DefaultStyle, _Measurement {
    
    public typealias Graph = Double.NumberTextGraph
    public typealias Value = Double
    public typealias Input = Double
    
    public typealias Width = Measurement<Unit>.FormatStyle.UnitWidth
    @usableFromInline typealias Format = _MeasurementFormat<Unit>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var unit: Unit
    public var width: Width
    public var locale: Locale
    
    public var bounds: Bounds?
    public var precision: Precision?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(unit: Unit, width: Width = .abbreviated, locale: Locale = .autoupdatingCurrent) {
        self.unit = unit; self.width = width; self.locale = locale
    }
    
    //*========================================================================*
    // MARK: * Cache
    //*========================================================================*
    
    public final class Cache: _DefaultCache {
        public typealias Value = Double
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var style: _MeasurementStyle
        @usableFromInline let preferences: Preferences<Input>

        @usableFromInline let parser: Parser<Format>
        @usableFromInline let formatter: Formatter<Format>
        @usableFromInline let interpreter: Interpreter
        @usableFromInline let label: Label
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        #warning("This needs to be tested........")
        @inlinable init(_ style: _MeasurementStyle) {
            let format = Format(unit: style.unit,
            width:style.width,locale: style.locale)
            //=----------------------------------=
            // N/A
            //=----------------------------------=
            self.style = style
            self.parser = Parser(initial: format)
            self.formatter = Formatter(initial: format)
            //=----------------------------------=
            // Formatter
            //=----------------------------------=
            let formatter = MeasurementFormatter()
            formatter.locale = format.locale
            formatter.unitStyle = format.style
            formatter.unitOptions = format.options

            formatter.numberFormatter = NumberFormatter()
            formatter.numberFormatter.locale = format.locale
            //=----------------------------------=
            // Formatter x None
            //=----------------------------------=
            assert(formatter.numberFormatter.numberStyle ==  .none)
            self.interpreter = .standard(formatter.numberFormatter)
            self.preferences = .standard()
            //=----------------------------------=
            // N/A
            //=----------------------------------=
            self.label = .measurement(format.base,unit:
            format.unit,  with: interpreter.components)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func compatible(_ style: Style) -> Bool {
            self.style.unit == style.unit &&
            self.style.width == style.width &&
            self.style.locale == style.locale
        }
        
        @inlinable func snapshot(_ characters: String) -> Snapshot {
            var snapshot = Snapshot(characters,
            as: { interpreter.attributes[$0] })
            label.autocorrect(&snapshot) /*--*/
            return snapshot /*---------------*/
        }
    }
}
