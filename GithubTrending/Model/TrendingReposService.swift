////  TrendingReposService.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

protocol TrendingReposServiceProtocol {
    func getTrendingRepos() async throws -> [TrendingRepoEntry]
}

struct TrendingReposService: TrendingReposServiceProtocol {
    private let trendingClient: any TrendingClient
    private let dataExtractor: SwiftSoupTrendingExtractor

    init(trendingClient: any TrendingClient, dataExtractor: SwiftSoupTrendingExtractor) {
        self.trendingClient = trendingClient
        self.dataExtractor = dataExtractor
    }

    func getTrendingRepos() async throws -> [TrendingRepoEntry] {
        let html = try await trendingClient.getTrendingPage()
        return try dataExtractor.extractTrending(from: html)
    }
}

