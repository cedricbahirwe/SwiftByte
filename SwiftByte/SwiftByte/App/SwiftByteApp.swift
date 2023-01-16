//
//  SwiftByteApp.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 19/12/2022.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

@main
struct SwiftByteApp: App {

    @UIApplicationDelegateAdaptor
    private var appDelegate: AppDelegate

    @Environment(\.scenePhase) private var scenePhase

    let persistenceController = PersistenceController.shared

    @StateObject var authViewModel = AuthenticationViewModel()

    @AppStorage(SBKeys.showWelcomeView.rawValue)
    private var showWelcomeView: Bool = true

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: handIncomingURL)
                .fullScreenCover(isPresented: $showWelcomeView) {
                    LaunchView(isPresented: $showWelcomeView)
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(authViewModel)

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
}
