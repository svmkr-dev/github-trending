////  FakeTrendingParser.swift
//  GithubTrending
//
//  Created on 14.04.2025.
//  
//

@testable import GithubTrending

struct FakeTrendingParser: TrendingParser {
    static let weeklyEntries = Array(sampleTrending[0...5])
    static let monthlyEntries = Array(sampleTrending[6...])

    func parseTrending(from input: String) throws -> [TrendingRepoEntry] {
        switch input {
        case FakeTrendingClient.weeklyPage: Self.weeklyEntries
        case FakeTrendingClient.monthlyPage: Self.monthlyEntries
        default: sampleTrending
        }
    }
}
