// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EventLoggerExercise",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "EventLogger",
            targets: ["EventLogger"]
        )
    ],
    targets: [
        .target(
            name: "EventLogger",
            path: "Sources/EventLogger"
        ),
        .testTarget(
            name: "EventLoggerTests",
            dependencies: ["EventLogger"],
            path: "Tests/EventLoggerTests"
        )
    ]
)
