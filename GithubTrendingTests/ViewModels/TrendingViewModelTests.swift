////  TrendingViewModelTests.swift
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
struct TrendingViewModelTests {

    @MainActor
    struct UsingDummyClient {
        let service: TrendingReposService
        let testObj: TrendingViewModel

        init() {
            let dummyClient = DummyTrendingClient()
            let parser = SwiftSoupTrendingParser()
            service = TrendingReposService(
                trendingClient: dummyClient,
                parser: parser
            )
            testObj = TrendingViewModel(service: service)
        }

        @Test func refreshShouldChangeCurrentRepositories() async {
            let repositoriesBeforeRefresh = testObj.repositories

            await testObj.refresh()

            #expect(repositoriesBeforeRefresh != testObj.repositories)
            #expect(testObj.repositories == sampleTrending)
        }

        @Test func refreshAfterDateRangeChangeShouldChangeCurrentRepositories() async  {
            await testObj.refresh()

            let repositoriesBeforeChange = testObj.repositories

            testObj.dateRange = .month
            await testObj.refresh()

            #expect(!testObj.repositories.isEmpty)
            #expect(testObj.currentState == .idle)
            #expect(repositoriesBeforeChange != testObj.repositories)
        }
    }

    @MainActor
    struct UsingFakeService {
        let fakeService: FakeTrendingService
        let testObj: TrendingViewModel

        init() {
            fakeService = FakeTrendingService()
            testObj = TrendingViewModel(service: fakeService)
        }

        @Test func refreshShouldChangeCurrentState() async {
            fakeService.actionBeforeReturn = { @MainActor in
                #expect(testObj.currentState == .loading)
            }

            #expect(testObj.currentState == .idle)
            await testObj.refresh()

            #expect(testObj.currentState == .idle)
        }

        @Test func refreshShouldSetErrorStateInCaseOfError() async {
            fakeService.errorToThrow = DummyError()

            await testObj.refresh()

            #expect(testObj.currentState == .error)
        }

        @Test func refreshShoudlReturnToIdleWhenCancelled() async {
            fakeService.errorToThrow = CancellationError()

            await testObj.refresh()

            #expect(testObj.currentState == .idle)
        }
    }

}
