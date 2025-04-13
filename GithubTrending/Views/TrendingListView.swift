////  TrendingListView.swift
//  GithubTrending
//
//  Created on 07.04.2025.
//  
//


import SwiftUI

struct TrendingRow: Identifiable {
    let id: Int
    let fullname: String
    let descritpiton: String
    let lang: String
    let stars: String
    let forks: String
    let starsSince: String
}
struct TrendingList {
    let rows: [TrendingRow]
}

struct TrendingListView: View {
    private let model: TrendingList

    @State var expanded: Set<TrendingRow.ID> = Set()

    var body: some View {
        ScrollView {
            ForEach(model.rows) { rowModel in
                TrendingRowView(model: rowModel, isExpanded: expanded.contains(rowModel.id))
                    .padding()
                    .background(.listRowBackground)
                    .cornerRadius(8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let (added, _) = expanded.insert(rowModel.id)
                        if !added {
                            expanded.remove(rowModel.id)
                        }
                    }
            }
        }
        .padding()
        .background(.listBackground)
        .navigationTitle("Trending")
        .animation(.bouncy(duration: 0.3), value: expanded)
        .refreshable {
            
        }
    }

    init(model: TrendingList) {
        self.model = model
    }
}

#Preview {
    NavigationStack {
        TrendingListView(model: TrendingList(rows: [
            TrendingRow(
                id: 1,
                fullname: "Lorem/Ipsum",
                descritpiton: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis neque sed sapien congue sagittis. Mauris ullamcorper vestibulum molestie.",
                lang: "Python",
                stars: "5,444",
                forks: "666",
                starsSince: "49"
            ),
            TrendingRow(
                id: 2,
                fullname: "Lorem/Ipsum",
                descritpiton: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis neque sed sapien congue sagittis. Mauris ullamcorper vestibulum molestie.",
                lang: "Python",
                stars: "5,444",
                forks: "666",
                starsSince: "49"
            )
        ]))
    }
}
