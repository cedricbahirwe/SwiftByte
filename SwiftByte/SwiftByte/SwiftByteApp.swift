//
//  SwiftByteApp.swift
//  SwiftByte
//
//  Created by Cédric Bahirwe on 19/12/2022.
//

import SwiftUI

@main
struct SwiftByteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
