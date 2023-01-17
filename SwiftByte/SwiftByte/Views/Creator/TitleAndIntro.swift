//
//  TitleAndIntro.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 17/01/2023.
//

import SwiftUI

extension CreatorView {
    struct TitleAndIntro: View {
        @Binding var title: String
        @Binding var intro: SBArticleContent
        var body: some View {
            Group {
                VStack(alignment: .leading) {
                    Text("Article Title")
                        .font(.title2.weight(.bold))
                    
                    TextField("Article Title", text: $title,
                              prompt: Text("Add Article title"),
                              axis: .vertical)
                    .applyField()
                }
                
                VStack(alignment: .leading) {
                    Text("Subtitle").font(.title3.weight(.bold))
                    
                    ContentEditor { bodyContent in
                        intro = bodyContent
                    }
                }
            }
        }
    }
}

struct TitleAndIntro_Previews: PreviewProvider {
    static var previews: some View {
        CreatorView.TitleAndIntro(title: .constant("Some title"), intro: .constant(.intro))
    }
}
