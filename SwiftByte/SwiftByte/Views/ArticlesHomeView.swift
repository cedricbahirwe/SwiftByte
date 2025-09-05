
//
//  ArticlesHomeView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

struct ArticlesHomeView: View {
    @StateObject private var store = ArticlesViewModel()

    @State private var showProfile = false

    var body: some View {
        List {
//            ScrollView(.horizontal, showsIndicators: false) {
//                filterTokensView
//            }
//            .listRowSeparator(.hidden)
//            .listRowBackground(EmptyView())
//            .listRowInsets(EdgeInsets())

            if store.articleVM.isEmpty {
               emptyContentView
            } else {
                articlesView
            }
        }
        .listStyle(.plain)
        .refreshable {
            store.fetchArticles()
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
                .presentationDetents([.height(300), .height(500)])
        }
//        .searchable(text: $store.searchText,
//                    tokens: $store.searchTokens,
//                    suggestedTokens: $store.searchSuggestedTokens,
//                    placement: .navigationBarDrawer(displayMode: .automatic),
//                    prompt: "Find a topic or concept",
//                    token: { token in
//            Text(token.value)
//        })
        .onSubmit(of: .search, store.filterSearchTokens)
        .onChange(of: store.searchTokens) {
            store.filterSearchTokens()
        }
        .onChange(of: store.searchTokens) { _, newTokens in
            prints("News \(newTokens.map(\.value))")
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                LogoView(scale: (0.7, .leading))
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
#if DEBUG
                NavigationLink(destination: NotificationsView()) {
                    Image(systemName: "bell.badge")
                }

                NavigationLink(destination: CreatorView()) {
                    Label("Go to creator", systemImage: "square.and.pencil")
                }
#endif

                Button(action: {
                    showProfile.toggle()
                }) {
                    Label("See Profile", systemImage: "person")
                        .symbolVariant(.circle)
                }
            }
        }
    }
}

#if DEBUG
struct ArticlesHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ArticlesHomeView()
        }
    }
}
#endif




private extension ArticlesHomeView {
    var filterTokensView: some View {
        HStack(spacing: 12) {
            ForEach(store.searchSuggestedTokens) { token in
                FilterToken(token: token,
                            fg: store.filterToken == token ? .offBackground : .primary,
                            bg: store.filterToken == token ? .accentColor : .clear)
                .overlay {
                    Capsule()
                        .strokeBorder(Color.accentColor)
                }
                .onTapGesture {
                    store.selectFilter(token)
                }
            }
        }
    }

    var articlesView: some View {
        ForEach(store.articleVM) { articleVM  in
            ZStack(alignment: .leading) {
                NavigationLink {
                    ArticleDetailView(articleVM)
                } label: { EmptyView() }
                    .opacity(0)

                ArticleRowView(articleVM: articleVM)
            }
            .listRowBackground(EmptyView())
            .listRowSeparator(.hidden)
            .listRowInsets(
                EdgeInsets(top: 8, leading: 16,
                           bottom: 8, trailing: 16)
            )
        }
    }

    var emptyContentView: some View {
        Color.clear
            .scaledToFit()
            .listRowBackground(EmptyView())
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .overlay {
                VStack  {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                    Text("No Content found")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Try searching a different topic or concept")
                    Text("**Tip**: Use few filters to get more results")
                }
                .foregroundStyle(.accent)
            }
    }
}
