//
//  LinksView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 18/01/2023.
//

import SwiftUI

extension CreatorView {
    struct LinksView: View {
        @Binding var art: SBArticle
        @State private var newLinkName = ""
        @State private var newLinkURL = ""
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Links \(art.moreResources.count)").font(.title2.weight(.bold))
                TextField("Add Link Name", text: $newLinkName)
                    .applyField()

                HStack {
                    TextField("Add Link URL", text: $newLinkURL)
                        .applyField()

                    Button("Add Link", action: addNewLink)
                        .bold()
                }

                ScrollView(.horizontal) {
                    HStack {
                        ForEach(art.moreResources, id: \.self) { source in
                            VStack(alignment: .leading) {
                                Text(source.description)
                                Text(source.url.description)
                                    .foregroundColor(.blue)
                            }
                            .padding(10)
                            .frame(maxWidth: 250)
                            .background(.regularMaterial)
                            .cornerRadius(10)
                            .contentShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture(count: 2) {
                                removeLink(source)
                            }
                        }
                    }
                }
            }
        }

        private func removeLink(_ link: SBLink) {
            if let index = art.moreResources.firstIndex(of: link) {
                art.moreResources.remove(at: index)
            }
        }

        private func addNewLink() {
            guard let newURL = URL(string: newLinkURL) else { return }
            let newName = newLinkName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : newLinkName


            if !art.moreResources.contains(where: {
                $0.name == newName ||
                $0.url == newURL
            }) {
                let newLink = SBLink(name: newName, url: newURL)
                self.art.moreResources.append(newLink)
            }

            self.newLinkName = ""
            self.newLinkURL = ""
        }
    }
}

struct LinksView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorView.LinksView(art: .constant(.sample))
    }
}
