////  TrendingListViewModelTests.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

import Observation
import Testing
@testable import GithubTrending

@MainActor
class FakeTrendingService: TrendingReposServiceProtocol {
    var actionBeforeReturn: (@MainActor @Sendable () -> ())?
    var errorToThrow: (any Error)?

    func getTrendingRepos() async throws -> [TrendingRepoEntry] {
        if let actionBeforeReturn {
            actionBeforeReturn()
        }

        if let errorToThrow {
            throw errorToThrow
        }

        return sampleTrending
    }
}

struct DummyError: Error {}

@MainActor
struct TrendingListViewModelTests {
    @Test func refreshShouldChangeCurrentRepositories() async {
        let dummyClient = DummyTrendingClient()
        let extractor = SwiftSoupTrendingExtractor()
        let service = TrendingReposService(
            trendingClient: dummyClient,
            dataExtractor: extractor
        )
        let testObj = TrendingListViewModel(service: service)
        let repositoriesBeforeRefresh = testObj.repositories

        await testObj.refresh()

        #expect(repositoriesBeforeRefresh != testObj.repositories)
        #expect(testObj.repositories == sampleTrending)
    }

    @Test func refreshShouldChangeCurrentState() async {
        let fakeService = FakeTrendingService()
        let testObj = TrendingListViewModel(service: fakeService)

        fakeService.actionBeforeReturn = { @MainActor in
            #expect(testObj.currentState == .loading)
        }

        #expect(testObj.currentState == .idle)
        await testObj.refresh()

        #expect(testObj.currentState == .idle)
    }

    @Test func refreshShouldSetErrorStateInCaseOfError() async {
        let fakeService = FakeTrendingService()
        let testObj = TrendingListViewModel(service: fakeService)

        fakeService.errorToThrow = DummyError()

        await testObj.refresh()

        #expect(testObj.currentState == .error)
    }

    @Test func refreshShoudlReturnToIdleWhenCancelled() async {
        let fakeService = FakeTrendingService()
        let testObj = TrendingListViewModel(service: fakeService)

        fakeService.errorToThrow = CancellationError()

        await testObj.refresh()

        #expect(testObj.currentState == .idle)
    }
}
