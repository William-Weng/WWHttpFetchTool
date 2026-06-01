//
//  CustomError.swift
//  WWHttpFetchTool
//
//  Created by William.Weng on 2026/5/29.
//

import Foundation

public extension WWHttpFetchTool {
    
    /// `WWHttpFetchTool` 執行過程中可能發生的錯誤。
    ///
    /// 此列舉集中定義網址驗證失敗、請求失敗，
    /// 以及回應內容解碼失敗等情境，並透過 `LocalizedError`
    /// 提供對應的錯誤描述。
    enum CustomError: LocalizedError, Sendable {
        
        case invalidURL         // 提供的網址字串無法建立為有效的 `URL`。
        case requestFailed      // HTTP 請求失敗，或伺服器回應的狀態碼不在成功範圍內。
        case decodingFailed     // 回應資料無法以 UTF-8 解碼成字串。
        
        /// 錯誤的可讀描述文字。
        public var errorDescription: String? {
            
            switch self {
            case .invalidURL: return "Invalid URL."
            case .requestFailed: return "Request failed."
            case .decodingFailed: return "Cannot decode response as UTF-8 text."
            }
        }
    }
}
