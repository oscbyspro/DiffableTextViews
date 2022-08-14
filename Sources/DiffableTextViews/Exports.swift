//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exports
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Basics
//=----------------------------------------------------------------------------=

@_exported import struct DiffableTextKit.ConstantTextStyle

@_exported import struct DiffableTextKit.EqualsTextStyle

@_exported import struct DiffableTextKit.NormalTextStyle

@_exported import struct DiffableTextKit.StandaloneTextStyle

@_exported import struct DiffableTextKit.PrefixTextStyle

@_exported import struct DiffableTextKit.SuffixTextStyle

@_exported import protocol DiffableTextKit.DiffableTextStyle

@_exported import protocol DiffableTextKit.NullableTextStyle

@_exported import protocol DiffableTextKit.WrapperTextStyle

//=----------------------------------------------------------------------------=
// MARK: + Styles
//=----------------------------------------------------------------------------=

@_exported import DiffableTextKitXNumber

@_exported import DiffableTextKitXPattern

//=----------------------------------------------------------------------------=
// MARK: + Platforms
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

@_exported import DiffableTextKitXUIKit

#endif
