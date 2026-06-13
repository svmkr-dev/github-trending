////  TrendingViewModel.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

import Observation
import Combine

@MainActor
@Observable
class TrendingViewModel {
    enum State: Equatable {
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
            notifyIfNeeded()
            currentState = .idle
        } catch is CancellationError {
            currentState = .idle
        } catch {
            currentState = .error
        }
    }

    // -MARK: iOS 18 UIKit support
    let repositoriesDidChange = PassthroughSubject<Void, Never>()
    private func notifyIfNeeded() {
        if #unavailable(iOS 26.0) {
            repositoriesDidChange.send()
        }
    }
}
