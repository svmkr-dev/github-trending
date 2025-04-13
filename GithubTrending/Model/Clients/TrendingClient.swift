////  TrendingClient.swift
//  GithubTrending
//
//  Created on 11.04.2025.
//  
//

protocol TrendingClient: Sendable {
    func getTrendingPage() async throws -> String
}
