// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//=----------------------------------------------------------------------------=
// MARK: Package
//=----------------------------------------------------------------------------=

let package = Package(
    name: "DiffableTextViews",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
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
        .target(
            name: "Support",
            dependencies: []),
    ]
)
