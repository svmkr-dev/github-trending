////  TrendingReposServiceTests.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

import Testing
@testable import GithubTrending

struct TrendingReposServiceTests {
    @Test("Should return entries for appropriate date range",
          arguments: DateRange.allCases)
    func getTrendingReposShouldReturnExpectedRepos(dateRange: DateRange) async throws {
        let client = FakeTrendingClient()
        let parser = FakeTrendingParser()
        let testObj = TrendingReposService(
            trendingClient: client,
            parser: parser
        )

        let results = try await testObj.getTrendingRepos(dateRange: dateRange)

        #expect(results == expectedValue(for: dateRange))
    }

    private func expectedValue(for dateRange: DateRange) -> [TrendingRepoEntry] {
        switch dateRange {
        case .today: sampleTrending
        case .week: FakeTrendingParser.weeklyEntries
        case .month: FakeTrendingParser.monthlyEntries
        }
    }

}

