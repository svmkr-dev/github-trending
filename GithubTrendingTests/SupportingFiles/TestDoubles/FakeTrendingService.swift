////  FakeTrendingService.swift
//  GithubTrending
//
//  Created on 14.04.2025.
//  
//

@testable import GithubTrending

@MainActor
class FakeTrendingService: TrendingReposServiceProtocol {
    var actionBeforeReturn: (@MainActor @Sendable () -> ())?
    var errorToThrow: (any Error)?
    var returnValuesMapping = [DateRange: [TrendingRepoEntry]]()

    func getTrendingRepos(dateRange: DateRange) async throws -> [TrendingRepoEntry] {
        if let actionBeforeReturn {
            actionBeforeReturn()
        }

        if let errorToThrow {
            throw errorToThrow
        }

        return sampleTrending
    }
}
