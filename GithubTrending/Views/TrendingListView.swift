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
    private let model: TrendingListViewModel
    @State private var expanded: Set<TrendingRepoEntry.ID> = Set()

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(model.repositories) { rowModel in
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
        }
        .padding()
        .background(.listBackground)
        .navigationTitle("Trending")
        .animation(.bouncy(duration: 0.3), value: expanded)
        .refreshable {
            await model.refresh()
        }
    }

    init(model: TrendingListViewModel) {
        self.model = model
    }
}

#Preview {
    let dummyClient = DummyTrendingClient()
    let extractor = SwiftSoupTrendingExtractor()
    let service = TrendingReposService(
        trendingClient: dummyClient,
        dataExtractor: extractor
    )

    let viewModel = TrendingListViewModel(service: service)
    NavigationStack {
        TrendingListView(model: viewModel)
    }
}
