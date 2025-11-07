import Foundation
import FirebaseAuth
import Observation // for @Observable (iOS 17+)

@MainActor
@Observable
class AuthManager {
    var user: User?
    @ObservationIgnored private var handle: AuthStateDidChangeListenerHandle?

    init() {
        // Listen for auth changes
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            // Ensure we mutate on the main actor
            Task { @MainActor in
                self?.user = user
            }
        }

        // Current session
        if let current = Auth.auth().currentUser {
            self.user = current
        } else {
            // Anonymous sign-in (must be enabled in Firebase Console)
            Task {
                do {
                    let result = try await Auth.auth().signInAnonymously()
                    self.user = result.user
                } catch {
                    print("Anonymous sign-in failed:", error)
                }
            }
        }
    }

    deinit {
        if let handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    var isSignedIn: Bool { user != nil }

    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            print("Sign out error:", error)
        }
    }
}
