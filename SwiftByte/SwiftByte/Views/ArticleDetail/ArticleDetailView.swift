//
//  ArticleDetailView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

struct ArticleDetailView: View {
    @ObservedObject var articleVM: ArticleViewModel
    init(_ articleVM: ArticleViewModel) {
        self.articleVM = articleVM
    }

    private var article: SBArticle { articleVM.article }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                Text(article.title)
                    .font(.title.bold())

                ArticleAuthorView(author: article.author,
                              artistCreatedDate: article.createdDate)
                
                if let articleIntro = article.intro {
                    ArticleIntroductionView(intro: articleIntro)
                }

                ArticleBodyView(sections: article.content)

                ArticleLinksView(links: article.moreResources)

                ArticleTopicsview(topics: article.keywords)
            }
            .padding(.horizontal)
        }
        .safeAreaInset(edge: .bottom) {
            ArticleStatsView(
                views: article.views,
                likes: article.likes,
                articleCreatedDate: article.createdDate,
                onLike: { articleVM.like() },
                onBookMark: {}
            )
        }
        .background(Color.offBackground)
        .task {
            articleVM.view()
        }
    }
}

#if DEBUG
struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ArticleDetailView(.init(.sample))
        }
//        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 410, height: 1100))
    }
}
#endif
