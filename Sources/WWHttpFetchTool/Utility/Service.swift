//
//  Service.swift
//  WWHttpFetchTool
//
//  Created by William.Weng on 2026/5/29.
//

import Foundation

extension WWHttpFetchTool {
    
    final class Service: Sendable {
        
        init() {}

        /// 發送 HTTP 請求並回傳伺服器回應的文字內容。
        ///
        /// - Parameters:
        ///   - urlString: 要請求的網址字串。
        ///   - method: HTTP 方法，例如 `GET`、`POST`、`PUT`、`DELETE`。
        ///   - mode: 回傳內容模式，例如 `html`、`json`、`text` 或 `auto`。
        ///           目前此參數不影響最終輸出，僅保留作為未來擴充用途。
        ///   - headers: 額外要加入的 HTTP Header。
        ///
        /// - Returns: 伺服器回應內容，並以 UTF-8 字串形式回傳。
        ///
        /// - Throws:
        ///   - `CustomError.invalidURL`: `urlString` 無法建立為有效的 `URL`。
        ///   - `CustomError.requestFailed`: 請求失敗，或 HTTP 狀態碼不在 `200...299` 範圍內。
        ///   - `CustomError.decodingFailed`: 回傳資料無法以 UTF-8 解碼為字串。
        func fetch(urlString: String, method: String, mode: String, headers: [String: String]) async throws -> String {
            
            guard let url = URL(string: urlString) else { throw CustomError.invalidURL }
            
            var request = URLRequest(url: url)
            
            request.httpMethod = method.uppercased()
            request.setValue(
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Safari/605.1.15",
                forHTTPHeaderField: "User-Agent"
            )
            
            request.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
            request.setValue("en-US,en;q=0.9", forHTTPHeaderField: "Accept-Language")
            request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
            
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                throw CustomError.requestFailed
            }
            
            guard let text = String(data: data, encoding: .utf8) else { throw CustomError.decodingFailed }
            
            switch mode.lowercased() {
            case "html", "json", "text", "auto": return text
            default: return text
            }
        }
    }
}
