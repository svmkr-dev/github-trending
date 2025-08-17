////  TrendingView.swift
//  GithubTrending
//
//  Created on 07.04.2025.
//  
//


import SwiftUI

fileprivate struct InnerListView: View {
    private let model: TrendingViewModel
    @State private var expanded: Set<TrendingRepoEntry.ID> = Set()

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(model.repositories) { rowModel in
                    TrendingRowView(model: rowModel, isExpanded: expanded.contains(rowModel.id))
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
        .navigationTitle("Trending2")
        .animation(.bouncy(duration: 0.3), value: expanded)
        .overlay {
            if model.currentState == .error {
                ContentUnavailableView {
                    Label("Error retrieving repositories", systemImage: "x.circle.fill")
                } description: {
                    Text("Please try again")
                        .multilineTextAlignment(.center)
                } actions: {
                    Button(
                        "Refresh",
                        action: { Task { await model.refresh() } }
                    )
                        .padding()
                        .buttonStyle(.bordered)
                }
            }
        }
    }

    init(model: TrendingViewModel) {
        self.model = model
    }
}

struct TrendingListView: View {
    private let model: TrendingViewModel
    var body: some View {
        InnerListView(model: model)
            .refreshable {
                await model.refresh()
            }
            .onAppear {
                Task { await model.refresh() }
            }
    }

    init(model: TrendingViewModel) {
        self.model = model
    }
}

#Preview("Default state") {
    let dummyClient = DummyTrendingClient()
    let parser = SwiftSoupTrendingParser()
    let service = TrendingReposService(
        trendingClient: dummyClient,
        parser: parser
    )

    let viewModel = TrendingViewModel(service: service)
    NavigationStack {
        TrendingListView(model: viewModel)
    }
}

fileprivate struct ThrowingService: TrendingReposServiceProtocol {
    struct FakeError: Error {}

    func getTrendingRepos(dateRange: DateRange) async throws -> [TrendingRepoEntry] {
        throw FakeError()
    }
}

#Preview("Error state") {
    let service = ThrowingService()
    let viewModel = TrendingViewModel(service: service)

    NavigationStack {
        TrendingListView(model: viewModel)
    }
}
