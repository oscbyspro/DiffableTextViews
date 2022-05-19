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
// MARK: DiffableTextViews
//*============================================================================*

let package = Package(
    name: "DiffableTextViews",
    platforms: [
        .iOS(.v15),
        .macCatalyst(.v15),
        .macOS(.v12),
        .tvOS(.v15),
    ],
    products: [
        //=--------------------------------------=
        // DiffableTextViews
        //=--------------------------------------=
        .library(
            name: "DiffableTextViews",
            targets: ["DiffableTextViews"]),
    ],
    targets: [
        //=--------------------------------------=
        // 4 - DiffableTextViews
        //=--------------------------------------=
        .target(
            name: "DiffableTextViews",
            dependencies: [
                "DiffableTextStyles",
                "DiffableTextViewsXUIKit"]),
        //=--------------------------------------=
        // 3 - DiffableTextStyles
        //=--------------------------------------=
        .target(
            name: "DiffableTextStyles",
            dependencies: [
                "DiffableTextStylesXNumber",
                "DiffableTextStylesXPattern"]),
        //=--------------------------------------=
        // 2 - DiffableTextStylesXNumber
        //=--------------------------------------=
        .target(
            name: "DiffableTextStylesXNumber",
            dependencies: ["DiffableTextKit", "DiffableTextViewsXUIKit"]),
        .testTarget(
            name: "DiffableTextStylesXNumberTests",
            dependencies: ["DiffableTestKit", "DiffableTextStylesXNumber"]),
        //=--------------------------------------=
        // 2 - DiffableTextStylesXPattern
        //=--------------------------------------=
        .target(
            name: "DiffableTextStylesXPattern",
            dependencies: ["DiffableTextKit", "DiffableTextViewsXUIKit"]),
        .testTarget(
            name: "DiffableTextStylesXPatternTests",
            dependencies: ["DiffableTestKit", "DiffableTextStylesXPattern"]),
        //=--------------------------------------=
        // 1 - DiffableTextViewsXUIKit
        //=--------------------------------------=
        .target(
            name: "DiffableTextViewsXUIKit",
            dependencies: ["DiffableTextKit"]),
        .testTarget(
            name: "DiffableTextViewsXUIKitTests",
            dependencies: ["DiffableTestKit", "DiffableTextViewsXUIKit"]),
        //=--------------------------------------=
        // 0 - DiffableTextKit
        //=--------------------------------------=
        .target(
            name: "DiffableTextKit",
            dependencies: []),
        .testTarget(
            name: "DiffableTextKitTests",
            dependencies: ["DiffableTestKit", "DiffableTextKit"]),
        //=--------------------------------------=
        // T - DiffableTestKit
        //=--------------------------------------=
        .target(name: "DiffableTestKit", path: "Tests/DiffableTestKit")
    ]
)
