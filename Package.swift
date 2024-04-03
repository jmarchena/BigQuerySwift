// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "BigQuerySwift",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "BigQuerySwift",
            targets: ["BigQuerySwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Kitura/SwiftyRequest", from: "3.1.0"),
        .package(name: "Auth", url: "https://github.com/jmarchena/google-auth-library-swift.git", .branch("main")),
    ],
    targets: [
        .target(
            name: "BigQuerySwift",
            dependencies: ["SwiftyRequest",
                           .product(name: "OAuth2", package: "Auth")
                          ]),
        .testTarget(
            name: "BigQuerySwiftTests",
            dependencies: ["BigQuerySwift"]),
    ]
)
