//
//  ContentView.swift
//  TranslateMe
//
//  Created by Rezwan Mahmud on 11/5/25.
//

import SwiftUI
import FirebaseAuth

@MainActor
struct ContentView: View {
    @State private var auth = AuthManager()
    @State private var translator = TranslateManager()
    @State private var history = HistoryManager()

    var body: some View {
        Group {
            if let user = auth.user {
                // Show the main UI once a user exists
                TranslateView()
                    .environment(\.authManager, auth)
                    .environment(\.translateManager, translator)
                    .environment(\.historyManager, history)
                    // Start or refresh the listener whenever the UID changes
                    .task(id: user.uid) {
                        history.startListening(uid: user.uid)   // uid is a non-optional String
                    }
            } else {
                // Loading / sign-in state
                VStack(spacing: 12) {
                    ProgressView("Preparing…")
                    Text("Connecting and signing you in…")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Button("Try Again") {
                        Task { try? await Auth.auth().signInAnonymously() }
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        }
        .animation(.default, value: auth.user != nil)
    }
}
