//
//  SectionsView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 18/01/2023.
//

import SwiftUI

extension CreatorView {
    struct SectionsView: View {
        @Binding var art: SBArticle
        var body: some View {
            VStack(alignment: .leading) {
                Text("Section: \(art.content.count)")
                    .font(.title2.weight(.bold))

                ContentEditor {
                    guard let newContent = $0 else { return }
                    addNewContent(newContent)
                }
            }
        }

        private func addNewContent(_ content: SBArticleContent) {
            if !art.content.contains(where: { $0.body == content.body }) {
                art.content.append(content)
            }
        }
    }
}

#if DEBUG
struct SectionsView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorView.SectionsView(art: .constant(.sample))
    }
}
#endif
