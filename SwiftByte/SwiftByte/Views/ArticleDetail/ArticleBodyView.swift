//
//  ArticleBodyView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 05/09/2025.
//

import SwiftUI

struct ArticleBodyView: View {
    let sections: [SBArticleContent]
    var body: some View {
        ForEach(sections, id:\.self) { section in
            Text(section.body)
                .font(section.font)
                .foregroundStyle(section.fontColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(section.isBackgroundStyled ? 14 : 0)
                .background(section.backgroundColor ?? Color.clear)
                .cornerRadius(section.isBackgroundStyled  ? section.cornerRadius : 0)
        }
    }
}

//#Preview {
//    ArticleBodyView()
//}
