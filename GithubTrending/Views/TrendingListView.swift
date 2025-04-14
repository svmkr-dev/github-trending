////  TrendingListView.swift
//  GithubTrending
//
//  Created on 07.04.2025.
//  
//


import SwiftUI

struct TrendingListView: View {
    @Bindable private var model: TrendingListViewModel
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
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                let pickerTitle = stringFor(range: model.dateRange)

                Picker(pickerTitle, selection: $model.dateRange) {
                    ForEach(DateRange.allCases) { range in
                        Text(stringFor(range: range))
                    }
                    .onChange(of: model.dateRange) {
                        Task { await model.refresh() }
                    }
                }
            }
        }
    }

    init(model: TrendingListViewModel) {
        self.model = model
    }

    private func stringFor(range: DateRange) -> String {
        switch range {
        case .today: "Today"
        case .week: "This week"
        case .month: "This month"
        }
    }
}

#Preview {
    let dummyClient = DummyTrendingClient()
    let parser = SwiftSoupTrendingParser()
    let service = TrendingReposService(
        trendingClient: dummyClient,
        parser: parser
    )

    let viewModel = TrendingListViewModel(service: service)
    NavigationStack {
        TrendingListView(model: viewModel)
    }
}
