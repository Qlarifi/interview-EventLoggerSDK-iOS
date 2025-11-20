import Foundation

/// A simple event type used by the logger.
/// Assume this is part of a public SDK surface.
public struct Event: Sendable, Equatable {
    public let id: UUID
    public let name: String
    public let payload: [String: String]
    public let timestamp: Date

    public init(
        id: UUID = UUID(),
        name: String,
        payload: [String: String],
        timestamp: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.payload = payload
        self.timestamp = timestamp
    }
}
