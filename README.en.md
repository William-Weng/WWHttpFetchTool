# [WWHttpFetchTool](https://swiftpackageindex.com/William-Weng)

[![Swift-6.2](https://img.shields.io/badge/Swift-6.2-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![iOS-26.0](https://img.shields.io/badge/iOS-26.0-pink.svg?style=flat)](https://developer.apple.com/swift/)
![TAG](https://img.shields.io/github/v/tag/William-Weng/WWHttpFetchTool)
[![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

[English](./README.en.md) | [繁體中文](./README.md)

---

## 🎉 Overview
`WWHttpFetchTool` is a lightweight Swift utility for sending HTTP requests and returning the response content as plain text.

The goal of this package is to provide a simple, extensible, and easy-to-integrate interface for fetching remote web pages, JSON APIs, or general text content while keeping the public API clean and consistent.

This tool is especially suitable for use with **Apple Intelligence** and its **Tool Calling** capabilities, allowing Foundation Models to automatically invoke your HTTP tool when web data is needed.

## ✨ Features

- 🚀 Sends asynchronous requests using `URLSession`.
- 🧩 Supports custom HTTP methods, modes, and headers.
- 🌐 Includes browser-like default request headers.
- 🛡️ Provides explicit error types for clearer failure handling.
- 📦 Always returns the response as UTF-8 plain text for flexible post-processing.
- ✅ Designed with `Sendable` in mind for easier integration with Swift Concurrency.

## 📋 Components

`WWHttpFetchTool` currently includes the following main parts:

| Component | Description |
|----------|-------------|
| `WWHttpFetchTool` | The main tool type that conforms to `Tool`. |
| `Service` | Responsible for building `URLRequest`, performing the request, and reading the response content. |
| `CustomError` | Defines possible failure cases such as invalid URLs, request failures, and decoding failures. |
| `call(arguments:)` | Converts input arguments into request settings and returns the fetched result. |

## 📦 Installation

### Swift Package Manager

Add the package dependency to your `Package.swift`:

```swift
.dependencies: [
    .package(url: "https://github.com/your-name/WWHttpFetchTool.git", from: "0.1.2")
]
```

Then add it to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        "WWHttpFetchTool"
    ]
)
```

## 🚀 Usage

### Basic Example

```swift
import UIKit
import WWHttpFetchTool

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetch(url: "https://raw.githubusercontent.com/William-Weng/WWHttpFetchTool/refs/heads/main/LICENSE")
    }
}

extension ViewController {
    
    func fetch(url: String) {

        let tool = WWHttpFetchTool()
        let arguments = WWHttpFetchTool.Arguments(url: url, method: "GET", mode: "text", headers: [])

        Task {
            do {
                let result = try await tool.call(arguments: arguments)
                print(result.first ?? "")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
```

### Custom Headers

```swift
let arguments = WWHttpFetchTool.Arguments(
    url: "https://api.example.com/data",
    method: "GET",
    mode: "json",
    headers: [
        .init(name: "Authorization", value: "Bearer YOUR_TOKEN"),
        .init(name: "Accept", value: "application/json")
    ]
)
```

## 🧱 Error Handling

The tool currently defines the following errors:

- `invalidURL`: The provided URL string cannot be converted into a valid `URL`.
- `requestFailed`: The request failed or the HTTP status code is not within `200...299`.
- `decodingFailed`: The response data cannot be decoded as a UTF-8 string.

Example:

```swift
do {
    let result = try await tool.call(arguments: arguments)
    print(result)
} catch let error as WWHttpFetchTool.CustomError {
    print(error.localizedDescription)
} catch {
    print(error)
}
```

## 🧩 Design

`WWHttpFetchTool` separates responsibilities into clear components:

- `WWHttpFetchTool`: Exposes the public tool interface.
- `Service`: Focuses on HTTP requests and response reading.
- `CustomError`: Centralizes error semantics.

This design provides several benefits:

- Clearer API boundaries.
- Better maintainability and testability.
- Easier future extension for response parsing, request bodies, or additional configuration.

## 📌 Notes

- The response is currently returned as a UTF-8 string. If the server uses another encoding, extra handling may be required.
- The `mode` parameter is currently reserved for interface design and does not change the final returned content.
- If custom headers duplicate default headers, the later value overrides the earlier one.
- If duplicate header keys exist before building the dictionary, consider resolving them first to avoid unexpected behavior.

## 🔧 Future Ideas

- Support request bodies for `POST` / `PUT`.
- Support automatic detection of other text encodings.
- Support automatic parsing for JSON / HTML content.
- Add richer error details such as `failureReason` and `recoverySuggestion`.

