// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MDKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MDKit",
            targets: ["MDKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/colinc86/LaTeXSwiftUI", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-markdown.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MDKit",
            dependencies: [
                .product(name: "LaTeXSwiftUI", package: "LaTeXSwiftUI"),
                .product(name: "Markdown", package: "swift-markdown"),
            ]
        ),
    ]
)
