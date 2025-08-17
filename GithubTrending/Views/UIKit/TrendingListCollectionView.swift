////  TrendingListCollectionView.swift
//  GithubTrending
//
//  Created on 12.08.2025.
//  
//

import SwiftUI
import UIKit

struct TrendingCollectionView: UIViewControllerRepresentable {
    typealias UIViewControllerType = TrendingListCollectionView

    let model: TrendingViewModel

    func makeUIViewController(context: Context) -> TrendingListCollectionView {
        TrendingListCollectionView(model: model)
    }
    
    func updateUIViewController(_ uiViewController: TrendingListCollectionView, context: Context) {
    }
}

class TrendingListCollectionView: UICollectionViewController {
    private let model: TrendingViewModel
    private let cellRegistration: UICollectionView.CellRegistration<UICollectionViewCell, TrendingContentConfiguration>
    private var dataSource: UICollectionViewDiffableDataSource<Int, TrendingRepoEntry>?

    required init?(coder: NSCoder) {
        return nil
    }

    init(model: TrendingViewModel) {
        self.model = model

        cellRegistration = .init { cell, indexPath, configuration in
            cell.contentConfiguration = configuration
        }

        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        super.init(collectionViewLayout: layout)
        title = "Trending"
        let refreshAction = UIAction(title: "Refresh") { [weak self] _ in
            guard let self else { return }
            Task { await refresh() }
        }
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addAction(refreshAction, for: .valueChanged)
    }

    override func updateProperties() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TrendingRepoEntry>()
        snapshot.appendSections([0])
        snapshot.appendItems(model.repositories)
        Task { await dataSource?.apply(snapshot) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = UICollectionViewDiffableDataSource<Int, TrendingRepoEntry>(collectionView: collectionView) {
            [weak self]
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: TrendingRepoEntry) -> UICollectionViewCell? in
            guard let self else { return nil }
            let entry = model.repositories[indexPath.row]
            let configuration = TrendingContentConfiguration(
                fullname: entry.fullname,
                description: entry.description,
                lang: entry.lang,
                stars: entry.stars,
                forks: entry.forks,
                starsSinceText: entry.starsSinceText
            )

            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: configuration
            )
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        Task { await refresh() }
    }

    private func refresh() async {
        collectionView.refreshControl?.beginRefreshing()
        await model.refresh()
        collectionView.refreshControl?.endRefreshing()
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
    UINavigationController(rootViewController: TrendingListCollectionView(model: viewModel))
}
