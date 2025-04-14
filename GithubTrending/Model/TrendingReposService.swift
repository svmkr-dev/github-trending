////  TrendingReposService.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

enum DateRange: String, CaseIterable, Identifiable {
    case today
    case week
    case month

    var id: Self { self }
}

protocol TrendingReposServiceProtocol: Sendable {
    func getTrendingRepos(dateRange: DateRange) async throws -> [TrendingRepoEntry]
}

struct TrendingReposService: TrendingReposServiceProtocol {
    private let trendingClient: any TrendingClient
    private let parser: any TrendingParser

    init(trendingClient: any TrendingClient, parser: any TrendingParser) {
        self.trendingClient = trendingClient
        self.parser = parser
    }

    func getTrendingRepos(dateRange: DateRange) async throws -> [TrendingRepoEntry] {
        let html = try await trendingClient.getTrendingPage(dateRange: dateRange)
        return try parser.parseTrending(from: html)
    }
}

