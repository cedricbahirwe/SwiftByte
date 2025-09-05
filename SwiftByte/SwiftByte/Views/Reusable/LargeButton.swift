//
//  LargeButton.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 15/01/2023.
//

import SwiftUI

typealias LButton = LargeButton
struct LargeButton: View {
    private let text: LocalizedStringKey
    private let action: () -> Void
    private let fgColor: Color
    private let bgColor: Color

    init(_ text: LocalizedStringKey,
         fg: Color = Color.offBackground,
         bg: Color = Color.accentColor,
         action: @escaping () -> Void) {
        self.text = text
        self.action = action
        self.fgColor = fg
        self.bgColor = bg
    }

    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.body.weight(.medium))
                .foregroundStyle(fgColor)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(bgColor)
                .cornerRadius(10)
        }
    }
}

struct LargeButton_Previews: PreviewProvider {
    static var previews: some View {
        LargeButton("Read more") { }
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
