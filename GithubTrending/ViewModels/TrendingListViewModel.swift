////  TrendingListViewModel.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

import Observation

@MainActor
@Observable
class TrendingListViewModel {
    enum State {
        case idle, loading, error
    }

    private let service: any TrendingReposServiceProtocol

    private(set) var repositories: [TrendingRepoEntry] = []
    private(set) var currentState = State.idle

    var dateRange: DateRange = .today

    init(service: any TrendingReposServiceProtocol) {
        self.service = service
    }

    func refresh() async {
        do {
            currentState = .loading
            repositories = try await service.getTrendingRepos(dateRange: dateRange)
            currentState = .idle
        } catch is CancellationError {
            currentState = .idle
        } catch {
            currentState = .error
        }
    }
}
