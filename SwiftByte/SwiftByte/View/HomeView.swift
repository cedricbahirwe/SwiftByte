//
//  HomeView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @State private var searchText = ""

    @State private var searchTokens: [SearchToken] = []

    @State private var searchSuggestedTokens =  ["UIKit", "Swift",  "SwiftUI", "iOS", "GCD", "Modifier"].map(SearchToken.init)

    var body: some View {
        List {
            ForEach(items) { item in
                VStack(alignment: .leading) {
                    Text("")
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }

            }
            .onDelete(perform: deleteItems)
        }
        .searchable(text: $searchText,
                    tokens: $searchTokens,
                    suggestedTokens: $searchSuggestedTokens,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "Find a topic or concept",
                    token: { token in
            Text(token.value)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
        HomeView()
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
