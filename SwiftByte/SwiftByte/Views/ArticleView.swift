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
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                Text(article.title)
                    .font(.title.bold())
                authorView
                introView
                sectionsView
                resourcesView
                topicsView
            }
            .padding(.horizontal)
        }
//        .navigationTitle(navTitle)
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar(content: {
//            ToolbarItemGroup(placement: .principal) {
//                Text("")
//            }
//        })
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 20) {
                Group {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkle")
                            .foregroundStyle(.yellow)

                        Text(article.createdDate, format: .dateTime.month().day().year())
                    }
                    .fixedSize()

                    if article.views > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "eye")
                                .symbolVariant(.fill)
                            Text(article.views.formatted())
                        }
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "hand.thumbsup")
                            .symbolVariant(.fill)
                        if article.likes > 0 {
                            Text(article.likes.formatted())

                        }
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        articleVM.like()
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "bookmark")
                    }
                }
                .imageScale(.large)
                .frame(maxWidth: .infinity)
                .font(.footnote)
                .fontWeight(.light)
            }
            .padding()

            .frame(maxWidth: .infinity)
            .overlay(alignment: .top) {
                Divider()
            }
            .background(.ultraThinMaterial)
        }
        .background(Color.offBackground)
        .task {
            articleVM.view()
        }
    }

    var navTitle: String {
        if article.views > 1 {
            return "\(article.views) Views"
        } else {
            return article.title
        }
    }
}

private extension ArticleView {
    var authorView: some View {
        VStack {
            Divider()
            HStack {
                if let author = article.author {
                    Text(author.getInitials())
                        .font(.footnote)
                        .fontDesign(.monospaced)
                        .fontWeight(.bold)
                        .kerning(1)
                        .padding(4)
                        .background(.secondary)
                        .background(.ultraThinMaterial)
                        .clipShape(.circle)

                    Text(author.getFullName())
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.medium)
                        .opacity(0.9)
                    Spacer(minLength: 4)
                }

                Text(article.createdDate, format: .dateTime.month().day().year())
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
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
                    .foregroundStyle(intro.fontColor)
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
                .foregroundStyle(section.fontColor)
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
                                .underline()
                                .tint(.accent)
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

    private var topicsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(article.keywords, id:\.self) { keyword in
                    Text(keyword.name)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(.quinary)
                        .clipShape(.capsule)
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding(.vertical, 30)
    }
}

#if DEBUG
struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ArticleView(.init(.sample))
        }
//        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 410, height: 1100))
    }
}
#endif
