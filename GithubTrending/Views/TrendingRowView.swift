////  TrendingRowView.swift
//  GithubTrending
//
//  Created on 13.04.2025.
//  
//

import SwiftUI

struct SmallTrendingRowView: View {
    private let model: TrendingRepoEntry

    var body: some View {
        HStack {
            Text(model.fullname)
                .font(.system(.body, design: .monospaced, weight: .regular))
                .foregroundStyle(.blue)
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "star")
                Text("\(model.starsSinceText)")
                    .font(.caption)
            }
        }
    }

    init(model: TrendingRepoEntry) {
        self.model = model
    }
}

struct ExpandedRowView: View {
    private let model: TrendingRepoEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Language: \(model.lang)")
            Text(model.description)
            HStack {
                Text("\(Image(systemName: "star")) \(model.stars) stars")
                Text("\(Image(systemName: "arrow.trianglehead.branch")) \(model.forks) forks")
            }
        }
    }

    init(model: TrendingRepoEntry) {
        self.model = model
    }
}

struct TrendingRowView: View {
    private let model: TrendingRepoEntry
    private let isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SmallTrendingRowView(model: model)
            if isExpanded {
                ExpandedRowView(model: model)
            }
        }
        .padding()
        .background(.listRowBackground)
        .cornerRadius(8)
        .contentShape(Rectangle())
    }

    init(model: TrendingRepoEntry, isExpanded: Bool) {
        self.model = model
        self.isExpanded = isExpanded
    }
}

#Preview {
    let row = TrendingRepoEntry(
        fullname: "Lorem/Ipsum",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis neque sed sapien congue sagittis. Mauris ullamcorper vestibulum molestie.",
        lang: "Python",
        stars: "5,444",
        forks: "666",
        starsSinceText: "49 stars today"
    )
    let secondRow = TrendingRepoEntry(
        fullname: "Lorem/Ipsum",
        description: "dolor sit amet",
        lang: "Python",
        stars: "5,444",
        forks: "666",
        starsSinceText: "49 stars today"
    )

    Group {
        TrendingRowView(model: row, isExpanded: false)
        TrendingRowView(model: row, isExpanded: true)
        TrendingRowView(model: secondRow, isExpanded: true)
    }
    .padding()
}
