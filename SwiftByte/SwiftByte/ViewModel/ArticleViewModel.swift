//
//  ArticleViewModel.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Combine

final class ArticleViewModel: Identifiable, ObservableObject {
    @Published var article: SBArticle

    private(set) var id: Int?

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
}
