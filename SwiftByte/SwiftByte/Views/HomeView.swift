
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

    var body: some View {
        List {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(searchSuggestedTokens) { token in
                        Text(token.value)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
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
                ArticleRowView(articleVM: articleVM)
                    .listRowBackground(EmptyView())
                    .listRowSeparator(.hidden)
                    .listRowInsets(
                        EdgeInsets(top: 10, leading: 12,
                                   bottom: 15, trailing: 12)
                    )
            }
        }
        .navigationTitle(Text("Let's Explore today's"))
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
                Button(action: {}) {
                    Label("See Notifications", systemImage: "bell.badge")
                }

                Button(action: {}) {
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
