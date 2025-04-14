////  GithubTrendingApp.swift
//  GithubTrending
//
//  Created on 07.04.2025.
//  
//


import SwiftUI

@main
struct GithubTrendingApp: App {
    @State var viewModel: TrendingViewModel

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TrendingView(model: viewModel)
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

        viewModel = TrendingViewModel(service: service)
    }
}
