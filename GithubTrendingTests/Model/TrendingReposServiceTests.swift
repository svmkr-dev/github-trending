////  TrendingReposServiceTests.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

import Testing
@testable import GithubTrending

struct TrendingReposServiceTests {
    @Test func getTrendingReposShouldReturnExpectedRepos() async throws {
        let client = DummyTrendingClient()
        let parser = SwiftSoupTrendingParser()
        let testObj = TrendingReposService(
            trendingClient: client,
            parser: parser
        )

        let results = try await testObj.getTrendingRepos()

        #expect(results == sampleTrending)
    }
}

