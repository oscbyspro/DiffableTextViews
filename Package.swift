// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Item

struct Item {
    // MARK: Properties
    
    let name: String
    
    // MARK: Calculations
    
    var tests: String {
        name + "Tests"
    }
    
    var dependency: Target.Dependency {
        .init(stringLiteral: name)
    }
    
    var path: String {
        "../" + name
    }
    
    var url: String {
        "https://github.com/oscbyspro/" + name
    }
}

// MARK: Source

let TextViews = Item(name: "TextViews")

// MARK: - Package

let package = Package(
    name: TextViews.name,
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: TextViews.name,
            targets: [TextViews.name]),
    ],
    targets: [
        .target(
            name: TextViews.name,
            dependencies: []),
        .testTarget(
            name: TextViews.tests,
            dependencies: [TextViews.dependency])
    ]
)
