//
//  LogoView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 15/01/2023.
//

import SwiftUI

struct LogoView: View {
    var isHighlighted = true
    var scale: (CGFloat, UnitPoint) = (size: 1.0, anchor: .center)
    var body: some View {
        textContentView
            .overlay(content: {
                if isHighlighted {
                    Image("laptop")
                        .resizable()
                        .scaledToFill()
                        .mask(textContentView)
                }
            })
            .clipped()
            .shadow(color: .white, radius: 0.4, x: 0, y: 0)
            .scaleEffect(scale.0, anchor: scale.1)
    }

    private var textContentView: some View {
        Text("SwiftByte")
            .foregroundColor(.accentColor)
            .font(.sysRound(.largeTitle))
            .fontWeight(.bold)
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
