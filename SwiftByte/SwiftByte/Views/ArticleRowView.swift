//
//  ArticleRowView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

struct ArticleRowView: View {
    @ObservedObject var articleVM: ArticleViewModel

    private var article: SBArticle { articleVM.article }
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let author = article.author {
                Text("By \(author.getFullName())")
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .opacity(0.9)
                Divider()
            }

            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.system(.title2, design: .rounded))

                if let intro = article.intro {
                    Text(intro.body)
                        .font(.system(.body, design: intro.design?.value))
                        .opacity(0.8)
                        .lineLimit(2)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .background(Color.offBackground)
        .cornerRadius(10)
        .shadow(color: .lightShadow, radius: 2, x: -2, y: -2)
        .shadow(color: .darkShadow, radius: 2, x: 2, y: 2)
    }
}

#if DEBUG
struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRowView(articleVM: .init(.sample))
            .padding()
            .previewLayout(.fixed(width: 410, height: 400))
    }
}
#endif
