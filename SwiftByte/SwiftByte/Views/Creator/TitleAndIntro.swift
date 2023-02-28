//
//  TitleAndIntro.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 17/01/2023.
//

import SwiftUI

extension CreatorView {
    struct TitleAndIntro: View {
        @Binding var art: SBArticle

        var body: some View {
            Group {
                VStack(alignment: .leading) {
                    Text("Article Title")
                        .font(.title2.weight(.bold))
                    
                    TextField("Article Title", text: $art.title,
                              prompt: Text("Add Article title"),
                              axis: .vertical)
                    .applyField()
                }
                
                VStack(alignment: .leading) {
                    Text("Subtitle").font(.title3.weight(.bold))
                    
                    ContentEditor(content: art.intro ?? SBArticleContent(body: "")) {
                        art.intro = $0
                    }
                }
            }
        }
    }
}

struct TitleAndIntro_Previews: PreviewProvider {
    static var previews: some View {
        CreatorView.TitleAndIntro(art: .constant(.sample))
    }
}
