// swift-tools-version:5.5
//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import PackageDescription

//*============================================================================*
// MARK: Sliders
//*============================================================================*

let package = Package(
    name: "Sliders",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        //=--------------------------------------=
        // Sliders
        //=--------------------------------------=
        .library(
            name: "Sliders",
            targets: ["Sliders"])
    ],
    targets: [
        //=--------------------------------------=
        // Sliders
        //=--------------------------------------=
        .target(name: "Sliders"),
    ]
)
