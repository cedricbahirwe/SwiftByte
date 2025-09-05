//
//  ArticleIntroductionView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 05/09/2025.
//

import SwiftUI

struct ArticleIntroductionView: View {
    let intro: SBArticleContent
    var body: some View {
        Text(intro.body)
            .font(intro.font)
            .foregroundStyle(intro.fontColor)
            .padding(intro.isBackgroundStyled ? 14 : 0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(intro.isBackgroundStyled ? intro.backgroundColor : Color.clear)
    }
}

//#Preview {
//    ArticleIntroductionView()
//}
