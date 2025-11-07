//
//  TranslateMeApp.swift
//  TranslateMe
//
//  Created by Rezwan Mahmud on 11/5/25.
//

import SwiftUI
import FirebaseCore

@main
struct TranslateMeApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
