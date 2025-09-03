//
//  ContentView.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 19/12/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        NavigationStack {
            switch authViewModel.state {
            case .signedIn:
              HomeView()
            case .signedOut:
              AuthenticationView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
