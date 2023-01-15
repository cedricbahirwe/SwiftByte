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

                    Text("Discover `ios Development` in \(Text("bits").foregroundColor(.red))")
                        .font(.title3)
                        .bold()

                    Text("Every concept, post andarticle listed in this app has been manually checked for relevancy and accuracy, making this one of the highest quality list of content related to iOS Development and Swift available on a mobile app.")

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
