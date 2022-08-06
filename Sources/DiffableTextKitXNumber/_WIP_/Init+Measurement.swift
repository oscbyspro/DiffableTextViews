//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Init x Measurement
//*============================================================================*

public extension DiffableTextStyle {
    
    @inlinable static func measurement<Unit>(_  unit: Unit) -> Self where
    Self == _MeasurementStyle<Unit> { Self.init(unit: unit) }
    
    @inlinable static func measurement<Unit>(_  unit: Unit) -> Self where
    Self == _OptionalStyle<_MeasurementStyle<Unit>> { Self(unit: unit) }
}
