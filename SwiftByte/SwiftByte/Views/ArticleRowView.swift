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
            HStack {
                if let author = article.author {
                    Text(author.fullName)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.medium)
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                }

                Spacer(minLength: 4)
                Text(article.createdDate, format: .relative(presentation: .named))
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.85)
                    .lineLimit(1)
            }

            Divider()

            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.system(.title2, design: .rounded))

                if let intro = article.intro {
                    Text(intro.body)
                        .font(.system(.body, design: intro.design?.value))
                        .opacity(0.8)
                        .lineLimit(4)
                }

                Button {
                    // Go to next
                } label: {
                    Text("Read more")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.vertical, 8)

            }
        }
        .padding(10)
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
