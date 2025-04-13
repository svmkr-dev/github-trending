////  TrendingViewModelTests.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

import Testing
@testable import GithubTrending

struct TrendingViewModelTests {
    @Test func refreshShouldChangeCurrentRepositories() async throws {
        let dummyClient = DummyTrendingClient()
        let extractor = SwiftSoupTrendingExtractor()
        let service = TrendingReposService(
            trendingClient: dummyClient,
            dataExtractor: extractor
        )
        let testObj = TrendingViewModel(service: service)
        let repositoriesBeforeRefresh = testObj.repositories

        await testObj.refresh()

        #expect(repositoriesBeforeRefresh != testObj.repositories)
        #expect(testObj.repositories == sampleTrending)
    }
}
