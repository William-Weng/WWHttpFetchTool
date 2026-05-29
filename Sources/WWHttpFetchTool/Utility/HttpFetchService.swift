//
//  WWHttpFetchTool.swift
//  WWHttpFetchTool
//
//  Created by William.Weng on 2026/5/29.
//

import Foundation

public extension WWHttpFetchTool {
    
    final class Service: Sendable {
        
        public init() {}
        
        public func fetch(urlString: String, method: String, mode: String, headers: [String: String]) async throws -> String {
            
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
