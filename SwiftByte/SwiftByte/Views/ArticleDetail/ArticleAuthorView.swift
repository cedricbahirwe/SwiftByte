//
//  ArticleAuthorView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 05/09/2025.
//

import SwiftUI

struct ArticleAuthorView: View {
    let author: SBAuthor?
    let artistCreatedDate: Date
    var body: some View {
        VStack {
            Divider()
            HStack {
                if let author = author {
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

                Text(artistCreatedDate, format: .dateTime.month().day().year())
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
        }
    }
}

//#Preview {
//    ArticleAuthorView()
//}
