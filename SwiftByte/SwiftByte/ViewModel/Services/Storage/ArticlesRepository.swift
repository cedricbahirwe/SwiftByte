//
//  ArticlesRepository.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class ArticlesRepository: ObservableObject {
    private let db = Firestore.firestore()

    @Published private(set) var articles = [SBArticle]()

    init() {
        loadArticles()
    }

    public func loadArticles() {
        db.collection(.articles)
            .order(by: "createdDate", descending: false)
            .addSnapshotListener { querySnapshot, error in
            if let error = error {
                printf("Firestore error: \(error).")
                return
            }

            if let querySnapshot = querySnapshot {
                let result = querySnapshot.documents.compactMap { document -> SBArticle? in
                    do {
                        let res = try document.data(as: SBArticle.self)
//                        prints(res)
                        return res
                    } catch {
                        printf("Firestore Decoding error: ", error, querySnapshot.documents.forEach { print($0.data()) } )
                        return nil
                    }
                }

                self.articles = result
            }
        }
    }

    public func loadArticles(by keyword: SBArticleKeyWord) {

        self.articles = articles.filter { $0.keywords.contains(keyword) }
    }

    public func addNewArticle(_ article: SBArticle) async -> Bool {
        do {
            return try await withCheckedThrowingContinuation({
                (continuation: CheckedContinuation<Bool, Error>) in
                do {
                    _ = try db.collection(.articles).addDocument(from: article) { error in
                        if let error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(returning: true)
                        }
                    }
                } catch {
                    printf("Could not add article: \(error).")
                    continuation.resume(throwing: error)

                }
            })
        }catch {
            printf("Could not add article: \(error).")
            return false

        }
//        do {
//            return try await withCheckedThrowingContinuation({
//                (continuation: CheckedContinuation<Bool, Error>) in
//                _ = try db.collection(.articles).addDocument(from: article, completion: { error in
//                    if let error {
//                        continuation.resume(throwing: error)
//                    } else {
//                        continuation.resume(returning: true)
//                    }
//                })
//
//            })
//        }
//        do {
//            let res = try db.collection(.articles).addDocument(from: article, completion: { error in
//                if let error {
//
//                }
//            })
//
//        } catch {
//            printf("Could not add article: \(error).")
//        }
    }

}
