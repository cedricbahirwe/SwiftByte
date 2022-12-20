//
//  SwiftByteApp.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 19/12/2022.
//

import SwiftUI
import GoogleSignIn

@main
struct SwiftByteApp: App {

    @UIApplicationDelegateAdaptor
    private var appDelegate: AppDelegate

    @Environment(\.scenePhase) private var scenePhase

    let persistenceController = PersistenceController.shared

    @StateObject var authViewModel = AuthenticationViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .onAppear(perform: restorePreviousSignIn)
                .onOpenURL(perform: handIncomingURL)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
        .onChange(of: scenePhase, perform: observeScenePhase)
    }

}

private extension SwiftByteApp {

    func observeScenePhase(_ scene: ScenePhase) {

        switch scene {
        case .background:
            print("Enter background mode")
        case .inactive:
            print("Enter inactive mode")
        case .active:
            print("Enter active mode")
        @unknown default:
            print("Enter unknown mode")
        }
    }

    func handIncomingURL(_ url: URL) {
        prints("Well, New URL: \(url)")
        GIDSignIn.sharedInstance.handle(url)
    }

    func restorePreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let user = user {
                self.authViewModel.state = .signedIn(user)
            } else if let error = error {
                self.authViewModel.state = .signedOut
                print("There was an error restoring the previous sign-in: \(error)")
            } else {
                self.authViewModel.state = .signedOut
            }
        }
    }
}
