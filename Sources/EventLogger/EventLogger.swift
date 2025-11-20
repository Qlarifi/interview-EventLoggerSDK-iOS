import Foundation
import Combine

/// Minimal event logger with a legacy Combine pipeline and
/// automatic flushing once the buffer reaches a threshold.
public final class EventLogger {

    private let flushThreshold = 250
    private var events: [Event] = []

    private var isFlushScheduled = false

    private let processingQueue = DispatchQueue(
        label: "com.example.EventLogger.processing",
        attributes: .concurrent
    )

    private let eventSubject = PassthroughSubject<Event, Never>()
    private var cancellables = Set<AnyCancellable>()

    public init() {
        eventSubject
            .receive(on: processingQueue)
            .sink { [weak self] event in
                guard let self = self else { return }
                self.events.append(event)

                if self.events.count >= self.flushThreshold && self.isFlushScheduled == false {
                    self.isFlushScheduled = true

                    let delay = Double.random(in: 0.001...0.004)
                    self.processingQueue.asyncAfter(deadline: .now() + delay) {
                        self.flushInternal()
                    }
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Public API

    /// Logs an event to the internal buffer.
    public func log(_ event: Event) {
        eventSubject.send(event)
    }

    // MARK: - Internal API

    /// Returns a snapshot of the current buffer (for tests / diagnostics).
    internal func currentBuffer() -> [Event] {
        var snapshot: [Event] = []
        processingQueue.sync {
            snapshot = self.events
        }
        return snapshot
    }

    // MARK: - Private (auto-flush)

    /// Private flush invoked automatically when threshold is reached.
    private func flushInternal() {
        processingQueue.async {
            let toSend = self.events
            self.events.removeAll(keepingCapacity: true)

            self.isFlushScheduled = false

            // Simulate async “network send”.
            DispatchQueue.global().async {
                _ = toSend.count
            }
        }
    }
}
