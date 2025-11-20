import XCTest
@testable import EventLogger

final class EventLoggerStressTests: XCTestCase {

    private func eventually(timeout: TimeInterval = 3.0,
                            pollInterval: TimeInterval = 0.01,
                            condition: @escaping () -> Bool) -> Bool {
        let end = Date().addingTimeInterval(timeout)
        while Date() < end {
            if condition() { return true }
            Thread.sleep(forTimeInterval: pollInterval)
        }
        return condition()
    }

    func testConcurrentLoggingUnderStress() {
        // Repeat the stress test 10 times as it appears to be intermittently crashing.
        for i in 1...10 {
            print("Test Run \(i)")
            _testConcurrentLoggingUnderStress()
        }
    }

    /// Stress test: heavy concurrent logging with automatic flushing.
    func _testConcurrentLoggingUnderStress() {
        let logger = EventLogger()

        let iterations = 1000
        let workers = 4

        let group = DispatchGroup()
        let allDone = expectation(description: "All workers finished")

        for workerID in 0..<workers {
            group.enter()
            DispatchQueue.global().async {
                for i in 0..<iterations {
                    Thread.sleep(forTimeInterval: Double.random(in: 0.0015...0.0045))

                    let event = Event(
                        name: "event-\(i)",
                        payload: ["worker": "\(workerID)", "index": "\(i)"]
                    )
                    logger.log(event)
                }
                group.leave()
            }
        }

        group.notify(queue: .global()) { allDone.fulfill() }
        wait(for: [allDone], timeout: 30.0)

        // Give auto-flushes a moment to run after the storm.
        let belowThreshold = eventually(timeout: 3.0, pollInterval: 0.01) {
            logger.currentBuffer().count < 250
        }
        XCTAssertTrue(belowThreshold, "Expected buffer to drop below threshold after auto-flush eventually runs")

        // Broad sanity invariant.
        let remaining = logger.currentBuffer()
        XCTAssertLessThanOrEqual(remaining.count, iterations * workers)
    }
}
