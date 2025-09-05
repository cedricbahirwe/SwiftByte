//
//  LaunchView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 15/01/2023.
//

import SwiftUI

struct LaunchView: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            LogoView()
                .padding()

            VStack(alignment: .leading) {
                Image(.laptop)
                    .resizable()
                    .scaledToFit()

                VStack(alignment: .leading, spacing: 10) {

                    Text("Discover `iOS Development` in \(Text("bits").foregroundColor(.red))")
                        .font(.title3)
                        .bold()

                    Text("Discover a curated library of bite-sized content on iOS development and Swift—every topic, post, and article has been carefully reviewed for accuracy and relevance, all in one convenient mobile app.")

                    LButton("Get Started") {
                        isPresented = false
                    }
                    .padding()
                }
                .padding()
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .leading)
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(isPresented: .constant(true))
    }
}
