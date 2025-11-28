# SwiftData Without SwiftUI – Example Project

This repository shows a **minimal, focused example of using SwiftData without SwiftUI**.

Most tutorials wire SwiftData through SwiftUI using `@Model`, `@Environment(\.modelContext)`, and `@ModelContainer`.  
This project demonstrates how to:

- Use **SwiftData in a non-SwiftUI context** (e.g. UIKit, AppKit, or background / service layers).
- Create a Database Service manager class.
- Perform **CRUD operations** on models from plain Swift code.
- Share a **single data layer** between different parts of your app, without relying on SwiftUI environment injection.

---

## Requirements

- **Xcode:** 15 or later  
- **iOS/macOS:** A platform version that supports SwiftData  
- **Swift:** 5.9+

---
