//
//  CustomError.swift
//  WWHttpFetchTool
//
//  Created by William.Weng on 2026/5/29.
//

import Foundation

public extension WWHttpFetchTool {
    
    enum CustomError: LocalizedError, Sendable {
        
        case invalidURL
        case requestFailed
        case decodingFailed
        
        public var errorDescription: String? {
            
            switch self {
            case .invalidURL: return "Invalid URL."
            case .requestFailed: return "Request failed."
            case .decodingFailed: return "Cannot decode response as UTF-8 text."
            }
        }
    }
}
