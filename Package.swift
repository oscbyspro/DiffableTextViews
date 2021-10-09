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
    
    var localPath: String {
        "../" + name
    }
    
    var remoteURL: String {
        "https://github.com/oscbyspro/" + name
    }
}

// MARK: Source

let TextFields = Item(name: "TextFields")

// MARK: Dependencies

let Sequences = Item(name: "Sequences")

// MARK: - Package

let package = Package(
    name: "TextFields",
    products: [
        .library(
            name: TextFields.name,
            targets: [TextFields.name]),
    ],
    dependencies: [
        .package(path: Sequences.localPath),
    ],
    targets: [
        .target(
            name: TextFields.name,
            dependencies: [Sequences.dependency]),
    ]
)
