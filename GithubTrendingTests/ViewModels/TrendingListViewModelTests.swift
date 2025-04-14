////  TrendingListViewModelTests.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

import Observation
import Testing
@testable import GithubTrending

struct DummyError: Error {}

@MainActor
struct TrendingListViewModelTests {
    @Test func refreshShouldChangeCurrentRepositories() async {
        let dummyClient = DummyTrendingClient()
        let parser = SwiftSoupTrendingParser()
        let service = TrendingReposService(
            trendingClient: dummyClient,
            parser: parser
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
