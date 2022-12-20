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
                .navigationTitle(
                  NSLocalizedString(
                    "Home",
                    comment: "Main Page navigation title"
                  ))
            case .signedOut:
              AuthenticationView()
                .navigationTitle(
                  NSLocalizedString(
                    "Welcome to SwiftByte",
                    comment: "Sign-in navigation title"
                  ))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
