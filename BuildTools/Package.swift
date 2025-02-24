// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.51.13")
    ],
    targets: [.target(name: "BuildTools", path: "")]
)
