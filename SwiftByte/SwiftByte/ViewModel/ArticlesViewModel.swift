//
//  ArticlesViewModel.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import Foundation
import Combine

final class ArticlesViewModel: ObservableObject {
    @Published private var articlesRepository = ArticlesRepository()
    @Published private(set) var articleVM = [ArticleViewModel]()

    @Published var searchSuggestedTokens = [SBSearchToken]()

    private var cancellables = Set<AnyCancellable>()

    init() {
        articlesRepository.$articles
            .map({ $0.map(ArticleViewModel.init) })
            .assign(to: \.articleVM, on: self)
            .store(in: &cancellables)

        articlesRepository.$articles
            .map({ $0.flatMap { $0.keywords.map({ SBSearchToken($0.name) }) } })
            .map({ Array(Set($0)) })
            .assign(to: \.searchSuggestedTokens, on: self)
            .store(in: &cancellables)
    }

    public func addNewArticle(_ article: SBArticle) {
        articlesRepository.addNewArticle(article)
    }

    public func insertNewArticle(_ article: SBArticle, at index: Int) {
        let articleVM = ArticleViewModel(article)
        self.articleVM.insert(articleVM, at: index)
    }
}

