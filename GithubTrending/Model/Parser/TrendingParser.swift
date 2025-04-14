////  TrendingParser.swift
//  GithubTrending
//
//  Created on 14.04.2025.
//  
//

protocol TrendingParser: Sendable {
    func parseTrending(from: String) throws -> [TrendingRepoEntry]
}
