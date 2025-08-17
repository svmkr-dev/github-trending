////  TrendingRepoEntry.swift
//  GithubTrending
//
//  Created on 12.04.2025.
//  
//

struct TrendingRepoEntry: Equatable, Hashable {
    let fullname: String
    let description: String
    let lang: String
    let stars: String
    let forks: String
    let starsSinceText: String
}

extension TrendingRepoEntry: Identifiable {
    var id: String {
        fullname
    }
}
