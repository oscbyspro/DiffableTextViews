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
// MARK: IntervalSliderViews
//*============================================================================*

let package = Package(
    name: "IntervalSliderViews",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        //=--------------------------------------=
        // IntervalSliderViews
        //=--------------------------------------=
        .library(
            name: "IntervalSliderViews",
            targets: ["IntervalSliderViews"])
    ],
    targets: [
        //=--------------------------------------=
        // IntervalSliderViews
        //=--------------------------------------=
        .target(name: "IntervalSliderViews"),
    ]
)
