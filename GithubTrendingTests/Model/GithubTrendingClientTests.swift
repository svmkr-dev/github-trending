////  GithubTrendingClientTests.swift
//  GithubTrending
//
//  Created on 11.04.2025.
//  
//

import Testing
@testable import GithubTrending

struct GithubTrendingClientTests {
    @Test func getTrendingPageShouldGetNonEmptyDocument() async throws {
        let testObj = GithubTrendingClient()

        let html = try await testObj.getTrendingPage()

        #expect(!html.isEmpty)
    }
}
