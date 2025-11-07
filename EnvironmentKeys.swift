//
//  EnvironmentKeys.swift
//  TranslateMe
//
//  Created by Rezwan Mahmud on 11/6/25.
//

import Foundation
import SwiftUI

// MARK: - Custom Environment Keys for your managers

private struct AuthManagerKey: EnvironmentKey {
    static let defaultValue = AuthManager()
}
private struct TranslateManagerKey: EnvironmentKey {
    static let defaultValue = TranslateManager()
}
private struct HistoryManagerKey: EnvironmentKey {
    static let defaultValue = HistoryManager()
}

extension EnvironmentValues {
    var authManager: AuthManager {
        get { self[AuthManagerKey.self] }
        set { self[AuthManagerKey.self] = newValue }
    }
    var translateManager: TranslateManager {
        get { self[TranslateManagerKey.self] }
        set { self[TranslateManagerKey.self] = newValue }
    }
    var historyManager: HistoryManager {
        get { self[HistoryManagerKey.self] }
        set { self[HistoryManagerKey.self] = newValue }
    }
}
