import XCTest
@testable import EventLogger

final class EventLoggerTests: XCTestCase {

    // Simple polling helper for "eventually" assertions.
    private func eventually(timeout: TimeInterval = 2.0,
                            pollInterval: TimeInterval = 0.01,
                            condition: @escaping () -> Bool) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if condition() { return true }
            // Let async work progress.
            Thread.sleep(forTimeInterval: pollInterval)
        }
        return condition()
    }

    func testAutoFlushTriggersAroundThreshold() {
        let logger = EventLogger()

        // Go slightly over the threshold to trigger auto-flush.
        for i in 0..<260 {
            logger.log(Event(name: "e-\(i)", payload: [:]))
        }

        // We don't assert immediately. We assert that EVENTUALLY the buffer drops below the threshold.
        let ok = eventually(timeout: 2.0, pollInterval: 0.01) {
            logger.currentBuffer().count < 250
        }
        XCTAssertTrue(ok, "Expected auto-flush to eventually reduce buffer below the threshold")
    }

    func testAutoFlushEventuallyOccursDuringBurst() {
        let logger = EventLogger()

        // Simulate a medium burst.
        for i in 0..<500 {
            logger.log(Event(name: "burst-\(i)", payload: [:]))
        }

        // The buffer may temporarily exceed 250. Assert it eventually settles below 250.
        let ok = eventually(timeout: 2.0, pollInterval: 0.01) {
            logger.currentBuffer().count < 250
        }
        XCTAssertTrue(ok, "Expected buffer to be below threshold after auto-flush eventually runs")
    }
}
