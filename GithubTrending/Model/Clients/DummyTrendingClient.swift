////  DummyTrendingClient.swift
//  GithubTrending
//
//  Created on 11.04.2025.
//  
//

import Foundation

struct DummyTrendingClient: TrendingClient {
    func getTrendingPage(dateRange: DateRange = .today) async throws -> String {
        guard let url = Bundle.main
            .url(forResource: resource(for: dateRange), withExtension: "html")
        else {
            throw InvalidDataError(data: nil)
        }

        return try String(contentsOf: url, encoding: .utf8)
    }

    private func resource(for dateRange: DateRange) -> String {
        switch dateRange {
        case .today: "trending"
        case .week: "weekly"
        case .month: "monthly"
        }
    }
}
