//
//  KeywordsView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 18/01/2023.
//

import SwiftUI

extension CreatorView {
    struct KeywordsView: View {
        @Binding var art: SBArticle
        @State private var newKeyword = ""

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Keywords \(art.keywords.count)")
                    .font(.title2.weight(.bold))
                HStack {
                    TextField("Add New Keyword", text: $newKeyword)
                        .applyField()

                    Button("Add", action: addKeyword)
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(art.keywords, id: \.self) { keyword in
                            Text(keyword.name)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(.regularMaterial)
                                .clipShape(Capsule())
                                .contentShape(Capsule())
                                .onTapGesture(count: 2) {
                                    removeKeyword(keyword)
                                }
                        }
                    }
                }
            }
        }

        private func addKeyword() {
            let newKeyword = newKeyword.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !newKeyword.isEmpty else { return }

            if !art.keywords.map(\.name).contains(newKeyword) {
                art.keywords.append(.init(newKeyword))
            }
            self.newKeyword = ""
        }

        private func removeKeyword(_ keyword: SBArticleKeyWord) {
            if let index = art.keywords.firstIndex(of: keyword) {
                art.keywords.remove(at: index)
            }
        }
    }
}

struct KeywordsView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorView.KeywordsView(art: .constant(.sample))
    }
}
