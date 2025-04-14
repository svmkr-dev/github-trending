////  SwiftSoupTrendingParserTests.swift
//  SwiftSoupTrendingParserTests
//
//  Created on 07.04.2025.
//  
//


import Foundation
import Testing
@testable import GithubTrending

struct SwiftSoupTrendingParserTests {

    @Test func shouldParseTrendingRepos() async throws {
        let trendingDoc = try #require(
            Bundle.main.url(forResource: "trending", withExtension: "html")
        )
        let trendingHtml = try String(contentsOf: trendingDoc, encoding: .utf8)
        let parser = SwiftSoupTrendingParser()

        let results = try parser.parseTrending(from: trendingHtml)

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
