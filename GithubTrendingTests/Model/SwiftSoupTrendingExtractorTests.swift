////  SwiftSoupTrendingExtractorTests.swift
//  SwiftSoupTrendingExtractorTests
//
//  Created on 07.04.2025.
//  
//


import Foundation
import Testing
@testable import GithubTrending

struct SwiftSoupTrendingExtractorTests {

    @Test func shouldExtractTrendingRepos() async throws {
        let trendingDoc = try #require(
            Bundle(for: BundleTag.self)
                .url(forResource: "trending", withExtension: "html")
        )
        let trendingHtml = try String(contentsOf: trendingDoc, encoding: .utf8)
        let extractor = SwiftSoupTrendingExtractor(html: trendingHtml)

        let results = try extractor.extractTrending()

        #expect(results.count == 12)

        for (index, repo) in results.enumerated() {
            #expect(repo.fullname == sampleTrending[index].fullname)
            #expect(repo.description == sampleTrending[index].description)
            #expect(repo.lang == sampleTrending[index].lang)
            #expect(repo.stars == sampleTrending[index].stars)
            #expect(repo.forks == sampleTrending[index].forks)
            #expect(repo.starsSinceText == sampleTrending[index].starsSinceText)
        }
    }

}
