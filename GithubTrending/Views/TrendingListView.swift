////  TrendingListView.swift
//  GithubTrending
//
//  Created on 07.04.2025.
//  
//


import SwiftUI

enum DateRange: String, CaseIterable, Identifiable {
    case today = "Today"
    case week = "This week"
    case month = "This month"

    var id: Self { self }
}

struct TrendingListView: View {
    private let model: TrendingListViewModel
    @State private var expanded: Set<TrendingRepoEntry.ID> = Set()
    @State private var range: DateRange = .today

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
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Picker(range.rawValue, selection: $range) {
                    ForEach(DateRange.allCases) { range in
                        Text(range.rawValue)
                    }
                    .onChange(of: range) {
                        Task { await model.refresh() }
                    }
                }
            }
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
