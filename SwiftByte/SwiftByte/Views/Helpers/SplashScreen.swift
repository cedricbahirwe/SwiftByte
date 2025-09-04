//
//  SplashScreen.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 04/09/2025.
//

import SwiftUI

struct SplashScreen: View {
    @State var isPresented = true
    var body: some View {
        LogoView()
            .scaleEffect(1.3)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background()
            .offset(x: isPresented ? 0 : -UIScreen.main.bounds.width)
            .animation(.default, value: isPresented)
            .task {
                if isPresented {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isPresented = false
                    }
                }
            }
    }
}

#Preview {
    SplashScreen()
}
