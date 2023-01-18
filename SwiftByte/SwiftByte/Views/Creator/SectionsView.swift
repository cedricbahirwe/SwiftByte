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
                Text("Article Content \(art.content.count)").bold()

                ContentEditor(completion: addNewContent)

            }
        }

        private func addNewContent(_ content: SBArticleContent) {
            if !art.content.contains(where: { $0.body == content.body }) {
                art.content.append(content)
            }
        }
    }
}

struct SectionsView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorView.SectionsView(art: .constant(.sample))
    }
}
