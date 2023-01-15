//
//  LogoView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 15/01/2023.
//

import SwiftUI

struct LogoView: View {
    var isHighlighted: Bool = true
    var body: some View {
        textContentView
            .overlay(content: {
                if isHighlighted {
                    Image(.laptop)
                        .resizable()
                        .scaledToFill()
                        .mask(textContentView)
                }
            })
            .clipped()
    }

    private var textContentView: some View {
        Text("SwiftByte")
            .foregroundColor(.accentColor)
            .font(.rounded(.largeTitle))
            .fontWeight(.bold)
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
