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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let author = article.author {
                    Text("\(author.getFullName())")
                        .font(.footnote)
                        .opacity(0.9)
                }
            }

            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.system(.title3, design: .rounded, weight: .bold))

                if let intro = article.intro {
                    Text(intro.body)
                        .font(.system(.headline, weight: .regular))
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }
            }

            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "sparkle")
                        .foregroundStyle(.yellow)

                    Text(article.createdDate, format: .dateTime.month().day().year())
                        .foregroundStyle(.secondary)
                }

                if article.likes > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "hand.thumbsup.fill")
                        Text(article.likes.formatted())
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .font(.caption)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.offBackground)
        .cornerRadius(10)
        .padding(4)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.foreground, lineWidth: 1)
        }
    }
}

#if DEBUG
struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ArticleRowView(articleVM: .init(.sample))

            ArticleRowView(articleVM: .init(.sample))
                .preferredColorScheme(.dark)
        }
        .padding()
        .previewLayout(.sizeThatFits)

    }
}
#endif
