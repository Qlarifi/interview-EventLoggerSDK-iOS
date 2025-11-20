# EventLogger Exercise
## Overview

You’ve joined a team that builds an event-logging SDK used by multiple iOS apps.

Recently, customers have started reporting an intermittent crash that appears under heavier usage, especially when multiple parts of the host app log events at the same time.

You’ve been given:

- The current implementation of the event logger (in `Sources/EventLogger`)
- A small test suite (in `Tests/EventLoggerTests`)

Your task is to help diagnose and fix the issue.

---

## Your Goals

1. Reproduce and investigate the issue

- Run the test suite.
- Observe the intermittent crash or failure.
- Walk through the implementation and form a hypothesis about the root cause.
- Explain how you arrived at your conclusion.

2. Propose and implement a fix

- Make the logger safe for concurrent use.
- You may restructure the logger if it leads to a cleaner or safer design.

3. Improve tests

- Strengthen the tests so this type of bug would be caught earlier.
- Add any new tests that support your solution.

4. Create a mock merge request description

Be ready to summarize:
- The root cause of the bug
- The solution you implemented
- Risks or considerations
- Follow-up work you'd recommend

---

## Getting Started

Requirements:
- Xcode 15+
- Swift 5.9+

Running tests in Xcode:
1. Open `Package.swift` in Xcode
2. Press `Command-U`

Running tests from the command line:

```
swift test
```

---

## What You Can Change

You may modify:
- Any code in `Sources/EventLogger`
- Any tests in `Tests/EventLoggerTests`
- Add additional source files or helper types if helpful

Please do not:
- Add external dependencies
- Redesign the entire project structure
- Introduce unrelated features

---

## Notes

This exercise includes a small Combine-based pipeline as part of the legacy implementation. You are free to keep it or remove it as part of modernizing the design.

Focus on correctness, clarity, and reasoning — not on making this production-ready.

Good luck, and have fun digging into it!
