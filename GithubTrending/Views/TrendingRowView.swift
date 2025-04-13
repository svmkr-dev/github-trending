////  TrendingRowView.swift
//  GithubTrending
//
//  Created on 13.04.2025.
//  
//

import SwiftUI

struct SmallTrendingRowView: View {
    private let model: TrendingRow

    var body: some View {
        HStack {
            Text(model.fullname)
                .font(.system(.body, design: .monospaced, weight: .regular))
                .foregroundStyle(.blue)
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "star")
                Text("\(model.starsSince) stars today")
                    .font(.caption)
            }
        }
    }

    init(model: TrendingRow) {
        self.model = model
    }
}

struct ExpandedRowView: View {
    private let model: TrendingRow

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Language: \(model.lang)")
            Text(model.descritpiton)
            HStack {
                Text("\(Image(systemName: "star")) \(model.stars) stars")
                Text("\(Image(systemName: "arrow.trianglehead.branch")) \(model.forks) forks")
            }
        }
    }

    init(model: TrendingRow) {
        self.model = model
    }
}

struct TrendingRowView: View {
    private let model: TrendingRow
    private let isExpanded: Bool

    var body: some View {
        VStack(spacing: 8) {
            SmallTrendingRowView(model: model)
            if isExpanded {
                ExpandedRowView(model: model)
            }
        }
    }

    init(model: TrendingRow, isExpanded: Bool) {
        self.model = model
        self.isExpanded = isExpanded
    }
}

#Preview {
    let row = TrendingRow(
        id: 1,
        fullname: "Lorem/Ipsum",
        descritpiton: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis neque sed sapien congue sagittis. Mauris ullamcorper vestibulum molestie.",
        lang: "Python",
        stars: "5,444",
        forks: "666",
        starsSince: "49"
    )

    Group {
        TrendingRowView(model: row, isExpanded: false)
        TrendingRowView(model: row, isExpanded: true)
    }
    .padding()
}
