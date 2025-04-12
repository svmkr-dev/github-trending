////  TrendingReposService.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

struct TrendingReposService {
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

