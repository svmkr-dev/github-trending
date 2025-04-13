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
        let extractor = SwiftSoupTrendingExtractor()
        let service = TrendingReposService(
            trendingClient: client,
            dataExtractor: extractor
        )

        viewModel = TrendingListViewModel(service: service)
    }
}
