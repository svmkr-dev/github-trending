////  TrendingClient.swift
//  GithubTrending
//
//  Created on 11.04.2025.
//  
//

enum DateRange: String, CaseIterable, Identifiable {
    case today = "daily"
    case week = "weekly"
    case month = "monthly"

    var id: Self { self }
}

protocol TrendingClient: Sendable {
    func getTrendingPage(dateRange: DateRange) async throws -> String
}
