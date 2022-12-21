//
//  ArticleViewModel.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Combine

final class ArticleViewModel: Identifiable, Hashable, ObservableObject {
    @Published var article: SBArticle

    private(set) var id: String?

    @Published private(set) var hasUserFollwed = false

    private var cancellables = Set<AnyCancellable>()

    private let userShops = [String]()
    init(_ article: SBArticle) {
        self.article = article

        $article
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }

    static func == (lhs: ArticleViewModel, rhs: ArticleViewModel) -> Bool {
        lhs.article == rhs.article
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(article)
    }


    func view() {
        article.views += 1
    }

    func like() {
        article.likes += 1
    }
}
