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
// MARK: * DiffableTextViews
//*============================================================================*

let package = Package(
    name: "DiffableTextViews",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        //=--------------------------------------=
        // MARK: DiffableTextViews
        //=--------------------------------------=
        .library(
            name: "DiffableTextViews",
            targets: [
                "DiffableTextViews",
                "NumericTextStyles",
                "PatternTextStyles"]),
    ],
    targets: [
        //=--------------------------------------=
        // MARK: DiffableTextViews
        //=--------------------------------------=
        .target(
            name: "DiffableTextViews",
            dependencies: ["Support"]),
        .testTarget(
            name: "DiffableTextViewsTests",
            dependencies: ["DiffableTextViews"]),
        //=--------------------------------------=
        // MARK: NumericTextStyles
        //=--------------------------------------=
        .target(
            name: "NumericTextStyles",
            dependencies: ["DiffableTextViews", "Support"]),
        .testTarget(
            name: "NumericTextStylesTests",
            dependencies: ["NumericTextStyles"]),
        //=--------------------------------------=
        // MARK: PatternTextStyles
        //=--------------------------------------=
        .target(
            name: "PatternTextStyles",
            dependencies: ["DiffableTextViews", "Support"]),
        .testTarget(
            name: "PatternTextStylesTests",
            dependencies: ["PatternTextStyles"]),
        //=--------------------------------------=
        // MARK: Support
        //=--------------------------------------=
        .target(name: "Support"),
    ]
)
