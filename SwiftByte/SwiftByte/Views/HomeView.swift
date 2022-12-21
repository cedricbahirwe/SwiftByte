
//
//  HomeView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI


struct HomeView: View {
    @State private var searchText = ""

    @State private var searchTokens: [SearchToken] = []

    @State private var searchSuggestedTokens =  ["UIKit", "Swift",  "SwiftUI", "iOS", "GCD", "Modifier"].map(SearchToken.init)

    @StateObject private var store = ArticlesViewModel()

    @State private var path: [ArticleViewModel] = [] // Nothing on the stack by default.

    @State private var showProfile = false

    @State private var showNotifications = false

    var body: some View {
        List {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(searchSuggestedTokens) { token in
                        Text(token.value)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.offBackground)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(Color.accentColor)
                            .clipShape(Capsule())
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(EmptyView())
            .listRowInsets(EdgeInsets())

            ForEach(store.articleVM) { articleVM  in
                ZStack(alignment: .leading) {
                    NavigationLink(value: articleVM) { EmptyView() }
                        .opacity(0)
                    ArticleRowView(articleVM: articleVM)
                }
                .listRowBackground(EmptyView())
                .listRowSeparator(.hidden)
                .listRowInsets(
                    EdgeInsets(top: 10, leading: 5,
                               bottom: 16, trailing: 5)
                )
            }
        }
        .navigationTitle(Text("Let's Explore today's"))
        .navigationDestination(for: ArticleViewModel.self, destination: { viewModel in
            ArticleView(viewModel)
        })
        .sheet(isPresented: $showNotifications, content: {
            NotificationsView()
        })
        .sheet(isPresented: $showProfile, content: {
            ProfileView()
        })
        .searchable(text: $searchText,
                    tokens: $searchTokens,
                    suggestedTokens: $searchSuggestedTokens,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "Find a topic or concept",
                    token: { token in
            Text(token.value)
        })

        .toolbar {
            ToolbarItemGroup {
                Button(action: {
                    showNotifications.toggle()
                }) {
                    Label("See Notifications", systemImage: "bell.badge")
                }

                Button(action: {
                    showProfile.toggle()
                }) {
                    Label("See Profile", systemImage: "person")
                        .symbolVariant(.circle)
                }
            }
        }
    }

    struct SearchToken: Identifiable {
        let id: UUID
        let value: String

        init(id: UUID = UUID(),_ value: String) {
            self.id = id
            self.value = value
        }

        init(_ value: String) {
            self.id = UUID()
            self.value = value
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
