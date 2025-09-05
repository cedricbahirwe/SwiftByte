//
//  ArticleTopicsview.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 05/09/2025.
//

import SwiftUI

struct ArticleTopicsview: View {
    let topics: [SBArticleKeyWord]
    var body: some View {
        if !topics.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(topics, id: \.self) { keyword in
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
}

//#Preview {
//    ArticleTopicsview()
//}
