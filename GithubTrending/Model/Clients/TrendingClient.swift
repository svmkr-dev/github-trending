////  TrendingClient.swift
//  GithubTrending
//
//  Created on 11.04.2025.
//  
//

protocol TrendingClient {
    func getTrendingPage() async throws -> String
}
