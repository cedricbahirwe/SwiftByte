//
//  ArticleLinksView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 05/09/2025.
//

import SwiftUI

struct ArticleLinksView: View {
    let links: [SBLink]
    var body: some View {
        if !links.isEmpty {
            Section {
                ForEach(links) { source in
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

//#Preview {
//    ArticleLinksView()
//}
