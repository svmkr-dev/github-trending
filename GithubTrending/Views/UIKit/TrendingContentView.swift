////  TrendingContentView.swift
//  GithubTrending
//
//  Created on 12.08.2025.
//  
//

import UIKit

struct TrendingContentConfiguration: UIContentConfiguration {
    let fullname: String
    let description: String
    let lang: String
    let stars: String
    let forks: String
    let starsSinceText: String

    private(set) var isExpanded = false

    init(fullname: String, description: String, lang: String, stars: String, forks: String, starsSinceText: String, isExpanded: Bool = false) {
        self.fullname = fullname
        self.description = description
        self.lang = lang
        self.stars = stars
        self.forks = forks
        self.starsSinceText = starsSinceText
        self.isExpanded = isExpanded
    }

    func makeContentView() -> any UIView & UIContentView {
        TrendingContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> TrendingContentConfiguration {
        guard let cellState = state as? UICellConfigurationState,
              cellState.isSelected else { return self }
        var updatedSelf = self
        updatedSelf.isExpanded.toggle()
        print("Updated self \(fullname) isExpanded: \(updatedSelf.isExpanded)")
        return updatedSelf
    }
}

@Observable
class TrendingContentView: UIView, UIContentView {
    var configuration: any UIContentConfiguration

    private let fullnameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let langLabel = UILabel()
    private let starsLabel = UILabel()
    private let forksLabel = UILabel()
    private let starsSinceLabel = UILabel()
    private let expandedContentStack: UIStackView

    required init?(coder: NSCoder) {
        return nil
    }

    init(configuration: TrendingContentConfiguration) {
        self.configuration = configuration

        fullnameLabel.font = .monospacedSystemFont(
            ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize,
            weight: .regular
        )
        fullnameLabel.textColor = .systemBlue
        fullnameLabel.lineBreakMode = .byWordWrapping
        fullnameLabel.numberOfLines = 0

        let star = UIImageView(image: UIImage(systemName: "star"))
        star.contentMode = .scaleAspectFit
        star.tintColor = .black

        starsSinceLabel.font = .preferredFont(forTextStyle: .caption1)

        let starsStack = UIStackView(arrangedSubviews: [
            star,
            starsSinceLabel
        ])
        starsStack.axis = .vertical
        starsStack.spacing = 8
        starsStack.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        fullnameLabel.setContentCompressionResistancePriority(
            starsStack.contentCompressionResistancePriority(for: .horizontal) - 1,
            for: .horizontal
        )

        let upperStack = UIStackView(arrangedSubviews: [
            fullnameLabel,
            starsStack
        ])
        upperStack.axis = .horizontal
        upperStack.distribution = .fill

        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0

        starsLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let starsAndForksStack = UIStackView(arrangedSubviews: [starsLabel, forksLabel])
        starsAndForksStack.axis = .horizontal
        starsAndForksStack.spacing = 8

        expandedContentStack = UIStackView(arrangedSubviews: [
            langLabel,
            descriptionLabel,
            starsAndForksStack
        ])
        expandedContentStack.axis = .vertical
        expandedContentStack.spacing = 8

        let mainStack = UIStackView(arrangedSubviews: [upperStack, expandedContentStack])
        mainStack.axis = .vertical
        mainStack.spacing = 8

        super.init(frame: .zero)

        mainStack.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 12
        mainStack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: padding,
            leading: padding,
            bottom: padding,
            trailing: padding
        )
        mainStack.isLayoutMarginsRelativeArrangement = true

        addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    override func updateProperties() {
        guard let configuration = configuration as? TrendingContentConfiguration else {
            return
        }

        fullnameLabel.text = configuration.fullname
        starsSinceLabel.text = configuration.starsSinceText

        langLabel.text = "Language: \(configuration.lang)"

        descriptionLabel.text = configuration.description

        let starsText = NSMutableAttributedString(string: " \(configuration.stars) stars")
        let starImage = UIImage(systemName: "star")!
        let starSymbol = NSMutableAttributedString(
            attachment: NSTextAttachment(image: starImage)
        )
        starsText.insert(starSymbol, at: 0)
        starsLabel.attributedText = starsText

        let forksText = NSMutableAttributedString(string: " \(configuration.forks) forks")
        let forksImage = UIImage(systemName: "arrow.trianglehead.branch")!
        let forksSymbol = NSMutableAttributedString(
            attachment: NSTextAttachment(image: forksImage)
        )
        forksText.insert(forksSymbol, at: 0)
        forksLabel.attributedText = forksText

        expandedContentStack.isHidden = !configuration.isExpanded
    }
}

#Preview {
    let row = TrendingContentConfiguration(
        fullname: "LoremLoremLoremLoremLorem/Ipsum",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis neque sed sapien congue sagittis. Mauris ullamcorper vestibulum molestie.",
        lang: "Python",
        stars: "5,444",
        forks: "666",
        starsSinceText: "49 stars today"
    )
    let secondRow = TrendingContentConfiguration(
        fullname: "Lorem/Ipsum",
        description: "dolor sit amet",
        lang: "Python",
        stars: "5,444",
        forks: "666",
        starsSinceText: "49 stars today",
        isExpanded: true
    )
    var state = UICellConfigurationState(traitCollection: UITraitCollection())
    state.isSelected = true

    let stack = UIStackView(arrangedSubviews: [
        row.makeContentView(),
        row.updated(for: state).makeContentView(),
        secondRow.makeContentView()
    ])
    stack.axis = .vertical
    return stack
}
