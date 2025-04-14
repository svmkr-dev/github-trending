////  SwiftSoupTrendingParser.swift
//  GithubTrending
//
//  Created on 08.04.2025.
//  
//

import SwiftSoup

struct SwiftSoupTrendingParser {
    private static let expectedStatsSpansCount = 3
    private static let expectedStatsLinksCount = 2

    func parseTrending(from trendingPageHtml: String) throws -> [TrendingRepoEntry] {
        let document = try SwiftSoup.parse(trendingPageHtml, "https://github.com/")
        let trendingRows = try document.select("article.Box-row")
        var results = [TrendingRepoEntry]()

        for row in trendingRows {
            try results.append(parseRow(row))
        }
        
        return results
    }

    private func parseRow(_ row: SwiftSoup.Element) throws -> TrendingRepoEntry {
        let statsSpans = try row.select("div>span")
        let lang: String
        let starsSinceText = try statsSpans.last()?.text(trimAndNormaliseWhitespace: true) ?? ""

        if statsSpans.count == SwiftSoupTrendingParser.expectedStatsSpansCount {
            lang = try statsSpans.first()?.text(trimAndNormaliseWhitespace: true) ?? ""
        } else {
            lang = ""
        }

        let starsAndForksLinks = try row.select("div>a.Link")
        let stars = try starsAndForksLinks.first()?.text(trimAndNormaliseWhitespace: true) ?? ""
        let forks: String

        if starsAndForksLinks.count == SwiftSoupTrendingParser.expectedStatsLinksCount {
            forks = try starsAndForksLinks.last()?.text(trimAndNormaliseWhitespace: true) ?? ""
        } else {
            forks = ""
        }

        return TrendingRepoEntry(
            fullname: try row.select("h2").text(trimAndNormaliseWhitespace: true)
                .split(separator: " ")
                .reduce("", +),
            description: try row.select("p").text(trimAndNormaliseWhitespace: true),
            lang: lang,
            stars: stars,
            forks: forks,
            starsSinceText: starsSinceText
        )
    }
}
