//
//  WWHttpFetchTool.swift
//  WWHttpFetchTool
//
//  Created by William.Weng on 2026/5/29.
//

import FoundationModels

/// 用來抓取指定 URL 內容的工具。
///
/// `WWHttpFetchTool` 會透過內部的 `Service` 發送 HTTP 請求，
/// 並將取得的回應內容以純文字形式回傳。
public struct WWHttpFetchTool: Tool {
    
    public var name: String = "httpFetch"
    public var description: String = "Fetch content from a URL and return it as plain text."
    
    private let service = Service()
    
    public init() {}
}

extension WWHttpFetchTool {

    @Generable
    public struct HeaderItem: Sendable {

        @Guide(description: "Header name.")
        public var name: String

        @Guide(description: "Header value.")
        public var value: String

        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }
    
    @Generable
    public struct Arguments: Sendable {

        @Guide(description: "The URL to fetch.")
        public var url: String

        @Guide(description: "HTTP method, for example GET or POST.")
        public var method: String?

        @Guide(description: "Optional mode: auto, text, html, or json.")
        public var mode: String?

        @Guide(description: "Optional headers as name-value pairs.")
        public var headers: [HeaderItem]?

        public init(url: String, method: String? = nil, mode: String? = nil, headers: [HeaderItem]? = nil) {
            self.url = url
            self.method = method
            self.mode = mode
            self.headers = headers
        }
    }
}

public extension WWHttpFetchTool {
    
    /// 執行工具呼叫並回傳抓取到的文字內容。
    ///
    /// 此方法會先將 `arguments.headers` 轉成 `[String: String]`，
    /// 再將網址、HTTP 方法、模式與標頭交給 `service.fetch(...)` 處理，
    /// 最後把結果包裝成單一字串陣列回傳。
    ///
    /// - Parameter arguments: 呼叫工具時傳入的參數內容。
    /// - Returns: 只包含一筆文字結果的字串陣列。
    /// - Throws: 當請求失敗、網址無效或內容解碼失敗時，會往外拋出對應錯誤。
    func call(arguments: Arguments) async throws -> [String] {
        
        let headers = Dictionary(uniqueKeysWithValues: (arguments.headers ?? []).map { ($0.name, $0.value) })
        
        let text = try await service.fetch(
            urlString: arguments.url,
            method: arguments.method ?? "GET",
            mode: arguments.mode ?? "auto",
            headers: headers
        )
        
        return [text]
    }
}
