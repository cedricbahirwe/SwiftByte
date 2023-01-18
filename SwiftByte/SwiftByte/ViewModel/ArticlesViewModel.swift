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

    // MARK: Search and Filter operations
    // Temporary store for filtering operation
    private var _allArticles = [ArticleViewModel]()

    @Published private(set) var filterToken: SBSearchToken?

    @Published var searchText = ""

    @Published var searchTokens: [SBSearchToken] = []

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

    /// Add New article to firebase
    public func addNewArticle(_ article: SBArticle) async -> Bool {
        await articlesRepository.addNewArticle(article)
    }

    /// Add New article locally
    public func insertNewArticle(_ article: SBArticle, at index: Int) {
        let articleVM = ArticleViewModel(article)
        self.articleVM.insert(articleVM, at: index)
    }

    /// Filter articles based on token
    public func selectFilter(_ token: SBSearchToken) {
        // Reset search filter
        searchText = ""
        // Handle Deselection

        if (filterToken == token) {
            articleVM = _allArticles
            filterToken = nil
        } else {
            _storeArticlesInTempo()
            let keyword = SBArticleKeyWord(token.value)
            articleVM = _allArticles.filter({
                $0.article.keywords.contains(keyword)
            })
            filterToken = token
        }
    }

    /// The algorithmic filtering approach here is to prioritize `token` search
    ///  and only fall back to text search when no token is found
    public func filterSearchTokens() {
        // Reset any token if set previously
        filterToken = nil
        if searchTokens.isEmpty {
            /// Search text
            if searchText.isEmpty {
                articleVM = _allArticles
            } else {
                let keyword = SBArticleKeyWord(searchText.lowercased())
                articleVM = _allArticles.filter({
                    $0.article.keywords.contains(keyword)
                })
            }
        } else {
            _storeArticlesInTempo()
            /// Search Token
            let keywords = searchTokens.map(\.value)
            articleVM = _allArticles.filter({
                $0.article.keywords.contains(where: {
                    keywords.contains($0.name)
                })
            })
        }
    }

    private func _storeArticlesInTempo() {
        if _allArticles.isEmpty {
            _allArticles = articleVM
        }
    }
}
