
//
//  HomeView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var store = ArticlesViewModel()

//    @State private var path: [ArticleViewModel] = [] // Nothing on the stack by default.

    @State private var showProfile = false

    @State private var showNotifications = false

    var body: some View {
        List {
            ScrollView(.horizontal, showsIndicators: false) {
                filterTokensView
            }
            .listRowSeparator(.hidden)
            .listRowBackground(EmptyView())
            .listRowInsets(EdgeInsets())

            #if DEBUG
            NavigationLink(destination: CreatorView.init) {
                Text("Go to Creator View")
            }
            #endif
            
            if store.articleVM.isEmpty {
               emptyContentView
            } else {
                articlesView
            }
        }
        .navigationTitle(Text("Let's Explore today's"))
        .sheet(isPresented: $showNotifications) {
            NotificationsView()
        }
        .sheet(isPresented: $showProfile, content: ProfileView.init)
        .searchable(text: $store.searchText,
                    tokens: $store.searchTokens,
                    suggestedTokens: $store.searchSuggestedTokens,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "Find a topic or concept",
                    token: { token in
            Text(token.value)
        })
        .onSubmit(of: .search, store.filterSearchTokens)
        .onChange(of: store.searchTokens) { _ in
            store.filterSearchTokens()
        }
        .onChange(of: store.searchTokens) { newTokens in
            prints("News \(newTokens.map(\.value))")
        }
        .toolbar {
            ToolbarItemGroup {
                Button(action: {
                    showNotifications.toggle()
                }) {
                    Label("See Notifications", systemImage: "bell.badge")
                }
                .hidden()
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


struct FilterToken: View {
    let token: SBSearchToken
    let fg: Color
    let bg: Color
    var body: some View {
        Text(token.value)
            .font(.callout)
            .fontWeight(.medium)
            .foregroundColor(fg)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(bg)
            .clipShape(Capsule())
    }
}

private extension HomeView {
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
                    ArticleView(articleVM)
                } label: { EmptyView() }
                    .opacity(0)
                ArticleRowView(articleVM: articleVM)
            }
            .listRowBackground(EmptyView())
            .listRowSeparator(.hidden)
            .listRowInsets(
                EdgeInsets(top: 10, leading: 5,
                           bottom: 10, trailing: 5)
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
                .foregroundColor(.accentColor)
            }
    }
}
