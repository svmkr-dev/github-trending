////  FakeTrendingClient.swift
//  GithubTrending
//
//  Created on 14.04.2025.
//  
//

@testable import GithubTrending

struct FakeTrendingClient: TrendingClient {
    static let weeklyPage = "weekly"
    static let monthlyPage = "monthly"

    func getTrendingPage(dateRange: DateRange) async throws -> String {
        switch dateRange {
        case .today: try await DummyTrendingClient().getTrendingPage()
        case .week: Self.weeklyPage
        case .month: Self.monthlyPage
        }
    }
}
