//
//  SwiftByteApp.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 19/12/2022.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth
import Firebase

@main
struct SwiftByteApp: App {

    @UIApplicationDelegateAdaptor
    private var appDelegate: AppDelegate

    @Environment(\.scenePhase) private var scenePhase

    let persistenceController = PersistenceController.shared

    @StateObject var authViewModel = AuthenticationViewModel()

    @AppStorage(SBKeys.showWelcomeView.rawValue)
    private var showWelcomeView: Bool = true

    @StateObject private var forceUpdate = ForceUpdateManager()

    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: handIncomingURL)
                .fullScreenCover(isPresented: $showWelcomeView) {
                    LaunchView(isPresented: $showWelcomeView)
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .alert(Text("App Update"),
                       isPresented: forceUpdate.isPresented,
                       presenting: forceUpdate.updateAlert) { alert in

                    ForEach(alert.buttons) {
                        Button($0.title, action: $0.action)
                    }
                } message: { alert in
                    Text(alert.message)
                }
                .environmentObject(authViewModel)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) {
                    print("applicationDidBecomeActive \($0.name)")
                    RemoteConfigs.shared.fetchRemoteValues({ _ in })
                }

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
