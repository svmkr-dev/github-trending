////  TrendingViewModel.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

import Observation

@MainActor
@Observable
class TrendingViewModel {
    enum State {
        case idle, loading, error
    }

    private let service: any TrendingReposServiceProtocol

    private(set) var repositories: [TrendingRepoEntry] = []
    private(set) var currentState = State.idle

    init(service: any TrendingReposServiceProtocol) {
        self.service = service
    }

    func refresh() async {
        do {
            currentState = .loading
            repositories = try await service.getTrendingRepos()
            currentState = .idle
        } catch {
            if error is CancellationError {
                currentState = .idle
            } else {
                currentState = .error
            }
        }
    }
}
