////  GithubTrendingApp.swift
//  GithubTrending
//
//  Created on 07.04.2025.
//  
//


import SwiftUI

@main
struct GithubTrendingApp: App {
    var body: some Scene {
        WindowGroup {
            TrendingListView(model: TrendingList(rows: []))
        }
    }
}
