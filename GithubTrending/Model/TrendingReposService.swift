////  TrendingReposService.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

protocol TrendingReposServiceProtocol: Sendable {
    func getTrendingRepos() async throws -> [TrendingRepoEntry]
}

struct TrendingReposService: TrendingReposServiceProtocol {
    private let trendingClient: any TrendingClient
    private let parser: SwiftSoupTrendingParser

    init(trendingClient: any TrendingClient, parser: SwiftSoupTrendingParser) {
        self.trendingClient = trendingClient
        self.parser = parser
    }

    func getTrendingRepos() async throws -> [TrendingRepoEntry] {
        let html = try await trendingClient.getTrendingPage(dateRange: .today)
        return try parser.parseTrending(from: html)
    }
}

