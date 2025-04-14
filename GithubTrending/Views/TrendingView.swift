////  TrendingView.swift
//  GithubTrending
//
//  Created on 07.04.2025.
//  
//


import SwiftUI

struct TrendingListView: View {
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
        .navigationTitle("Trending")
        .animation(.bouncy(duration: 0.3), value: expanded)
    }

    init(model: TrendingViewModel) {
        self.model = model
    }
}

struct TrendingView: View {
    @Bindable private var model: TrendingViewModel
    @State private var colorScheme: ColorScheme?

    var body: some View {
        TrendingListView(model: model)
            .refreshable {
                await model.refresh()
            }
            .toolbar(content: toolbar)
    }

    init(model: TrendingViewModel) {
        self.model = model
    }

    @ToolbarContentBuilder func toolbar() -> some ToolbarContent {
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

            // Embedding Picker in menu to show ellipsis on toolbar
            // instead of current selection
            Menu("\(Image(systemName: "ellipsis.circle"))") {
                Menu("Color scheme") {
                    Picker(
                        "\(Image(systemName: "ellipsis.circle"))",
                        selection: $colorScheme
                    ) {
                        Text("Automatic").tag(Optional<ColorScheme>.none)
                        Text("Light").tag(ColorScheme.light)
                        Text("Dark").tag(ColorScheme.dark)
                    }
                }
            }
        }
    }

    private func refreshAction() {
        Task { await model.refresh() }
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

    let viewModel = TrendingViewModel(service: service)
    NavigationStack {
        TrendingView(model: viewModel)
    }
}
