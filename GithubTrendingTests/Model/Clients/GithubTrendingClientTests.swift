////  GithubTrendingClientTests.swift
//  GithubTrending
//
//  Created on 11.04.2025.
//  
//

import Testing
@testable import GithubTrending

@Suite(
    .serialized,
    .tags(.com_example_recruitment_splunk.networking)
)
struct GithubTrendingClientTests {
    @Test func getTrendingPageShouldGetNonEmptyDocument() async throws {
        let testObj = GithubTrendingClient()

        let html = try await testObj.getTrendingPage()

        #expect(!html.isEmpty)
    }

    @Test func getTrendingPageShouldGetDistinctDocumentsForDifferentArgs() async throws {
        let testObj = GithubTrendingClient()

        let daily = try await testObj.getTrendingPage()
        let weekly = try await testObj.getTrendingPage(dateRange: .week)
        let monthly = try await testObj.getTrendingPage(dateRange: .month)

        #expect(daily != weekly)
        #expect(weekly != monthly)
        #expect(daily != monthly)
    }
}
