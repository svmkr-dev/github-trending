////  MainView.swift
//  GithubTrending
//
//  Created on 17.08.2025.
//  
//

import SwiftUI
enum UIBackend {
    case swiftUi, uiKit
}

struct MainView: View {
    @Bindable private var model: TrendingViewModel
    @State private var colorScheme: ColorScheme?
    @State private var uiImplementation = UIBackend.swiftUi

    var body: some View {
        NavigationStack {
            implementedView
            .toolbar(content: toolbar)
            .preferredColorScheme(colorScheme)
        }
    }

    @ViewBuilder var implementedView: some View {
        switch uiImplementation {
        case .swiftUi:
            TrendingListView(model: model)
        case .uiKit:
            TrendingCollectionView(model: model)
                .navigationTitle("Trending")
                .background(.listBackground)
        }
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
                Menu("UI implementation") {
                    Picker("UI implementation", selection: $uiImplementation) {
                        Text("SwiftUI").tag(UIBackend.swiftUi)
                        Text("UIKit").tag(UIBackend.uiKit)
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

#Preview("Default state") {
    let dummyClient = DummyTrendingClient()
    let parser = SwiftSoupTrendingParser()
    let service = TrendingReposService(
        trendingClient: dummyClient,
        parser: parser
    )

    let viewModel = TrendingViewModel(service: service)
    MainView(model: viewModel)
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

    MainView(model: viewModel)
}
