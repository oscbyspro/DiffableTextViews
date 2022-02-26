//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * Token x Key
//*============================================================================*

public protocol ColorID: TokenID { }

//*============================================================================*
// MARK: * Token x Color x Text
//*============================================================================*

public enum TextColorID: ColorID {
    @inlinable public static func update(_ view: UITextField, with value: UIColor) {
        view.textColor = value
    }
}

extension Token where ID == TextColorID {
    @inlinable public static func text(_ color: Value) -> Self {
        Self(color)
    }
}

//*============================================================================*
// MARK: * Token x Color x Selection
//*============================================================================*

public enum SelectionColorID: ColorID {
    @inlinable public static func update(_ view: UITextField, with value: UIColor) {
        view.tintColor = value
    }
}

extension Token where ID == SelectionColorID {
    @inlinable public static func selection(_ color: Value) -> Self {
        Self(color)
    }
}

#endif
