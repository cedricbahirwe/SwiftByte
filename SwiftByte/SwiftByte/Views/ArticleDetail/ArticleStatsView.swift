//
//  ArticleStatsView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 05/09/2025.
//

import SwiftUI

struct ArticleStatsView: View {
    let views: Int
    let likes: Int
    let articleCreatedDate: Date
    var onLike: () -> Void
    var onBookMark: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            Group {
                HStack(spacing: 4) {
                    Image(systemName: "sparkle")
                        .foregroundStyle(.yellow)

                    Text(articleCreatedDate, format: .dateTime.month().day().year())
                }
                .fixedSize()

                if views > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "eye")
                            .symbolVariant(.fill)
                        Text(views.formatted())
                    }
                }

#if DEBUG
                HStack(spacing: 4) {
                    if #available(iOS 17.0, *) {
                        Image(systemName: "hand.thumbsup")
                            .symbolVariant(.fill)
                            .symbolEffect(.bounce, value: likes)
                    } else {
                        Image(systemName: "hand.thumbsup")
                            .symbolVariant(.fill)
                    }
                    if likes > 0 {
                        Text(likes.formatted())

                    }
                }
                .contentShape(.rect)
                .onTapGesture {
                    onLike()
                }
#endif

                // TODO: - Implement Logic
#if DEBUG
                HStack(spacing: 4) {
                    Image(systemName: "bookmark")
                        .onTapGesture {
                            onBookMark()
                        }
                }
#endif
            }
            .imageScale(.large)
            .frame(minHeight: 32)
            .frame(maxWidth: .infinity)
            .font(.footnote)
            .fontWeight(.light)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Divider()
        }
    }
}

//#Preview {
//    ArticleStatsView()
//}
