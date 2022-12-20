//
//  ArticleView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 20/12/2022.
//

import SwiftUI

struct ArticleView: View {
    @ObservedObject var articleVM: ArticleViewModel
    init(_ articleVM: ArticleViewModel) {
        self.articleVM = articleVM
    }
    private var article: SBArticle { articleVM.article }
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
//                Group {
//                    if let url = URL(string: .shop.profilePicture ?? "") {
//                        AsyncImage(url: url){ image in
//                            image.resizable()
//                        } placeholder: {
//                            Color.gray
//                        }
//                    } else {
//                        Color.gray
//                    }
//                }
//                .clipShape(Circle())
//                .padding(2)
//                .background(.background)
//                .clipShape(Circle())
//                .padding(1)
//                .background(.secondary)
//                .clipShape(Circle())
//                .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 0) {
                    Text(article.title)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.medium)
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                    if let author = article.author {
                        Text(author.fullName)
                            .font(.caption)
                            .minimumScaleFactor(0.85)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Button {

                } label: {
                    Text("Follow")
                        .font(.system(.callout, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .frame(height: 32)
                        .background(.green, in: RoundedRectangle(cornerRadius: 13))
                        .overlay(RoundedRectangle(cornerRadius: 13).stroke(Color.green, lineWidth: 1))
                }
            }

            Color.gray
                .hidden()
//                .overlay(postImageView)
                .frame(maxWidth: 400, maxHeight: 400)
                .cornerRadius(10)


            VStack {
                Text(article.title)
                    .lineLimit(5)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal)
    }

//    private var postImageView: some View {
//        ZStack {
//            if let url = URL(string: art.images.isEmpty ? "" : post.images[0]) {
//                AsyncImage(url: url) { image in
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                } placeholder: {
//                    Color.gray
//                }
//            } else {
//                Color.gray
//            }
//        }
//    }
}


#if DEBUG
struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(.init(.sample))
    }
}
#endif
