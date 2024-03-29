// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TTBaseUIKit",
    platforms: [
        .macOS(.v10_15), .iOS(.v14), .tvOS(.v14), .watchOS(.v8)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TTBaseUIKit",
            targets: ["TTBaseUIKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TTBaseUIKit",
            dependencies: [],
            exclude: ["Info.plist"],
        resources: [
            //.copy("Support/Resources"),
            .process("Support/Resources/Fonts"),
            .process("Support/Resources/Images"),
        ]
        ),
        .testTarget(
            name: "TTBaseUIKitTests",
            dependencies: ["TTBaseUIKit"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
