//
//  WWHttpFetchTool.swift
//  WWHttpFetchTool
//
//  Created by William.Weng on 2026/5/29.
//

import FoundationModels

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
