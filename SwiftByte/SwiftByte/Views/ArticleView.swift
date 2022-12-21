//
//  ArticleView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

struct ArticleView: View {
    @ObservedObject var articleVM: ArticleViewModel
    init(_ articleVM: ArticleViewModel) {
        self.articleVM = articleVM
    }
    private var article: SBArticle { articleVM.article }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(article.title)
                    .font(.system(.title,
                                  design: .rounded,
                                  weight: .semibold))
                authorView
                introView
                sectionsView
                resourcesView
            }
        }
        .padding(.horizontal)
        .navigationTitle(article.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.offBackground)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "bookmark.circle")
            }
        }
    }
}

private extension ArticleView {
    var authorView: some View {
        VStack {
            Divider()
            HStack {
                if let author = article.author {
                    Text(author.fullName)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.medium)
                        .opacity(0.9)
                    Spacer(minLength: 4)
                }

                Text(article.createdDate, format: .relative(presentation: .named))
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
        }
    }

    var introView: some View {
        Group {
            if let intro = article.intro {
                Text(intro.body)
                    .font(intro.font)
                    .foregroundColor(intro.fontColor)
                    .padding(intro.isBackgroundStyled ? 14 : 0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(intro.isBackgroundStyled ? intro.backgroundColor : Color.clear)
            }
        }
    }

    var sectionsView: some View {
        ForEach(article.content, id:\.self) { section in

            Text(section.body)
                .font(section.font)
                .foregroundColor(section.fontColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(section.isBackgroundStyled ? 14 : 0)
                .background(section.backgroundColor ?? Color.clear)
                .cornerRadius(section.isBackgroundStyled  ? section.cornerRadius : 0)
        }
    }

    var resourcesView: some View {
        Group {
            if !article.moreResources.isEmpty {
                Section {
                    ForEach(article.moreResources, id:\.self) { source in
                        Link(destination: source.url) {
                            Label(source.description, systemImage: "link")
                                .italic()
                                .underline(pattern: .dashDotDot)
                                .tint(.blue)
                        }
                    }
                } header: {
                    Text("Read More:")
                        .font(.title2)
                        .opacity(0.85)
                }
            }
        }
    }
}

#if DEBUG
struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ArticleView(.init(.sample))
        }
    }
}
#endif
