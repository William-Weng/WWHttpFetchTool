# [WWHttpFetchTool](https://swiftpackageindex.com/William-Weng)

[![Swift-6.2](https://img.shields.io/badge/Swift-6.2-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![iOS-26.0](https://img.shields.io/badge/iOS-26.0-pink.svg?style=flat)](https://developer.apple.com/swift/)
![TAG](https://img.shields.io/github/v/tag/William-Weng/WWHttpFetchTool)
[![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

[English](./README.en.md) | [繁體中文](./README.md)

---

## 🎉 相關說明
`WWHttpFetchTool` 是一個輕量級 Swift 工具，用來發送 HTTP 請求，並將回應內容以純文字形式回傳。

此套件的目標是提供一個簡潔、可擴充、易於整合的介面，讓你可以快速抓取遠端網頁、JSON API 或一般文字內容，並保持 API 乾淨一致。

此工具特別適合用於 **Apple Intelligence** 的 **Tool Calling** 情境，例如讓 Foundation Models 在需要網路資料時自動呼叫你的 HTTP 工具。

## ✨ 核心特色

- 🚀 使用 `URLSession` 非同步發送請求。
- 🧩 支援自訂 HTTP Method、Mode 與 Headers。
- 🌐 內建常見瀏覽器風格的預設 Request Header。
- 🛡️ 提供明確的錯誤型別，方便上層處理失敗情境。
- 📦 回應內容統一以 UTF-8 純文字回傳，方便後續自行解析 HTML、JSON 或文字資料。
- ✅ 採用 `Sendable` 設計，較容易整合到 Swift Concurrency 流程中。

## 📋 功能概覽

`WWHttpFetchTool` 目前包含以下主要組件：

| 元件 | 說明 |
|------|------|
| `WWHttpFetchTool` | 工具主型別，符合 `Tool` 協定。 |
| `Service` | 負責建立 `URLRequest`、發送請求與讀取回應內容。 |
| `CustomError` | 定義工具可能發生的錯誤，例如無效網址、請求失敗與解碼失敗。 |
| `call(arguments:)` | 將輸入參數轉換為請求設定，並回傳抓取結果。 |

## 📦 安裝方式

### Swift Package Manager

在 `Package.swift` 中加入套件依賴：

```swift
.dependencies: [
    .package(url: "https://github.com/your-name/WWHttpFetchTool.git", from: "1.0.0")
]
```

並在 target 中加入：

```swift
.target(
    name: "YourTarget",
    dependencies: [
        "WWHttpFetchTool"
    ]
)
```

## 🚀 使用方式

### 基本使用

```swift
import Foundation

let tool = WWHttpFetchTool()

let arguments = WWHttpFetchTool.Arguments(
    url: "https://example.com",
    method: "GET",
    mode: "text",
    headers: []
)

Task {
    do {
        let result = try await tool.call(arguments: arguments)
        print(result.first ?? "")
    } catch {
        print(error.localizedDescription)
    }
}
```

### 自訂 Header

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

## 🧱 錯誤處理

工具目前定義了以下錯誤：

- `invalidURL`：輸入的網址字串無法轉成有效的 `URL`。
- `requestFailed`：請求失敗，或 HTTP 狀態碼不在 `200...299` 範圍內。
- `decodingFailed`：回應資料無法以 UTF-8 解碼成字串。

範例：

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

## 🧩 設計說明

`WWHttpFetchTool` 將請求處理拆成數個明確職責：

- `WWHttpFetchTool`：對外暴露工具介面。
- `Service`：專注在 HTTP 請求與資料讀取。
- `CustomError`：集中定義錯誤語意。

這樣的拆分方式有幾個好處：

- 讓 API 更清楚。
- 方便測試與維護。
- 未來若要擴充回應解析模式、Request Body 或更多設定，也比較容易演進。

## 📌 注意事項

- 目前回應內容會以 UTF-8 字串回傳，若伺服器使用其他編碼，可能需要額外處理。
- `mode` 參數目前主要作為介面保留，現階段不影響最終回傳內容。
- 若自訂 `headers` 與預設標頭重複，後設定的值會覆蓋前者。
- 若 `headers` 中存在重複 key，建議在建立 Dictionary 前先處理，以避免不預期行為。

## 🔧 未來可擴充方向

- 支援 `POST` / `PUT` 的 Request Body。
- 支援不同文字編碼自動判斷。
- 支援回應內容自動解析為 JSON / HTML。
- 支援更完整的錯誤資訊，例如 `failureReason` 與 `recoverySuggestion`。

