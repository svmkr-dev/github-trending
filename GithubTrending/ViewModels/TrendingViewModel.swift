////  TrendingViewModel.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

class TrendingViewModel {
    private let service: any TrendingReposServiceProtocol

    private(set) var repositories: [TrendingRepoEntry] = []

    init(service: any TrendingReposServiceProtocol) {
        self.service = service
    }

    func refresh() async {
        do {
            repositories = try await service.getTrendingRepos()
        } catch {}
    }
}
