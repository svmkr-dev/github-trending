////  GithubTrendingApp.swift
//  GithubTrending
//
//  Created on 07.04.2025.
//  
//


import SwiftUI

@main
struct GithubTrendingApp: App {
    @State var viewModel: TrendingListViewModel

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TrendingListView(model: viewModel)
            }
        }
    }

    init() {
        let client = GithubTrendingClient()
        let extractor = SwiftSoupTrendingParser()
        let service = TrendingReposService(
            trendingClient: client,
            parser: extractor
        )

        viewModel = TrendingListViewModel(service: service)
    }
}
