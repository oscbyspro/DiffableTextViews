// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DiffableTextViews",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "DiffableTextViews",
            targets: ["DiffableTextViews", "NumericTextStyles"]),
    ],
    targets: [
        // --------------------------------- //
        // MARK: DiffableTextViews
        // --------------------------------- //
        .target(
            name: "DiffableTextViews",
            dependencies: ["Utilities"]),
        .testTarget(
            name: "DiffableTextViewsTests",
            dependencies: ["DiffableTextViews"]),
        // --------------------------------- //
        // MARK: NumericTextStyles
        // --------------------------------- //
        .target(
            name: "NumericTextStyles",
            dependencies: ["DiffableTextViews", "Utilities"]),
        .testTarget(
            name: "NumericTextStylesTests",
            dependencies: ["NumericTextStyles"]),
        // --------------------------------- //
        // MARK: PatternTextStyles
        // --------------------------------- //
        .target(
            name: "PatternTextStyles",
            dependencies: ["DiffableTextViews", "Utilities"]),
        .testTarget(
            name: "PatternTextStylesTests",
            dependencies: ["PatternTextStyles"]),
        // --------------------------------- //
        // MARK: Utilities
        // --------------------------------- //
        .target(
            name: "Utilities",
            dependencies: []),
    ]
)

